//
//  AgendaEventCloudDatasource.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AgendaEventCloudDatasource {
    func loadDays() -> Observable<LoadDaysResponse> {
        return URLSession.shared.loadDays()
    }
    
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        return URLSession.shared.loadAgendaEvents(day: day)
    }
}

extension URLSession {
    
    func loadDays() -> Observable<LoadDaysResponse> {
        
        let url = URL(string: "http://ejeadefiestas.ejeadigital.com/index.php/api/fiestas/dias_con_eventos/id/200/format/json")!
        
        return self
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .map(Day.parse)
    }
    
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse>{
        let url = URL(string: "http://ejeadefiestas.ejeadigital.com/index.php/api/eventos/eventos_by_dia/id/200/dia/\(day.toString())/format/json")!
        
        return self
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .map(AgendaEvent.parse)
            
        
    }
    
}
