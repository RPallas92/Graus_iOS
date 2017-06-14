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
    
    func loadAgendaEvents() -> Observable<LoadAgendaEventsResponse> {
        return URLSession.shared.loadAgendaEvents()
    }
}

extension URLSession {
    func loadAgendaEvents() -> Observable<LoadAgendaEventsResponse> {
        //TODO one loaddays then map loadafenda for each day and then concat or traverse
        
        
        return loadDaysWithEvents()
            .flatMap { daysResponse -> Observable<LoadAgendaEventsResponse> in
                switch daysResponse {
                case .success(let days):
                    
                    let loadEventsForDayStreams = days.map { day in
                       return self.loadAgendaEvents(day: day)
                    }
                    
                    
                    /*let loadEventsForDaysStream = loadEventsForDayStreams.reduce(Observable<LoadAgendaEventsResponse>.empty(), { x,y in
                        x.concat(y)
                    })*/
                    
                    
                    let loadEventsForDaysStream = Observable.merge(loadEventsForDayStreams)
                    
                    
                
                    /*let result = loadEventsForDaysStream.reduce(LoadAgendaEventsResponse.success([]), accumulator: { (acc:LoadAgendaEventsResponse, xs:[LoadAgendaEventsResponse]) -> LoadAgendaEventsResponse in
                        acc.hackconcat(otherResult: xs[0])
                    })
                    return result.con*/
                    
                    return loadEventsForDaysStream
                
                case .failure(let error):

                    return Observable.just(LoadAgendaEventsResponse.failure(error))
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
