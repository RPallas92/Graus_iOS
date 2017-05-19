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
        //TODO one loaddays then map loadafenda for each day and then concat or traverse
        return loadDaysWithEvents()
            .map { daysResponse in
                switch daysResponse {
                case .success(let days):
                    
                    let loadEventsForDayStreams = days.map { day in
                       return self.loadAgendaEvents(day: day)
                    }
                    
                    let loadEventsForDaysStream = Observable.combineLatest(loadEventsForDayStreams)
                    

                    let result = loadEventsForDaysStream.map { hack2 in
                        hack2.reduce(hack2[0], { previous, current in
                            switch previous {
                            case .success(let events){
                                
                            }
                                
                            }
                            })
                    }
                    return result
                
                case .failure(let error):
                    return
                }
            }
        
    }
    
    func loadDaysWithEvents() -> Observable<LoadDaysWithEventsResponse> {
        
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
