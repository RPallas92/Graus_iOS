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
    func loadDaysWithEvents() -> Observable<LoadDaysWithEventsResponse> {
        return URLSession.shared.loadDaysWithEvents()
    }
}

extension URLSession {
    func loadAgendaEvents() -> Observable<LoadAgendaEventsResponse> {
        
        let url = URL(string: "http://ejeadefiestas.ejeadigital.com/index.php/api/fiestas/dias_con_eventos/id/200/format/json")!
        return self
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .map(AgendaEvent.parse)
    }
    
    func loadDaysWithEvents() -> Observable<LoadDaysWithEventsResponse> {
        
        let url = URL(string: "http://ejeadefiestas.ejeadigital.com/index.php/api/fiestas/dias_con_eventos/id/200/format/json")!

       return self
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .map(Day.parse)
    }
    
    /*func loadAgendaEvents(for: Day) -> Observable<LoadAgendaEventsResponse>{
        
    }*/
}
