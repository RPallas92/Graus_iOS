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
    
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        return URLSession.shared.loadDaysWithEvents(day: day)
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
    
    
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        
        
        func getNearDaysRange(days: [Day], day: Day) -> [Day]{
            let nearestDay = days.reduce(days.first) { old, current in
                guard let oldDay = old else {
                    return current
                }
                
                if (day > oldDay) {
                    return current
                } else {
                    return oldDay
                }
            }
            
            
            //let index = days.index(where: {$0 == nearestDay})
            
            return [nearestDay!]
        }
        return loadDays()
            .flatMap { daysResponse -> Observable<LoadDaysWithEventsResponse> in
                print(daysResponse)
                
                switch daysResponse {
                case .success(let days):
                    let nearestRange = getNearDaysRange(days: days, day: day)
                    let eventsForEachDay = nearestRange.map { day in
                            return self.loadAgendaEvents(day: day)
                    }
                    
                    let eventsArray = Observable.combineLatest(eventsForEachDay)
                    
                    let daysWithEvents = eventsArray.map { eventsArrays -> Result<(DaysWithEvents), ApiError> in
                        var daysWithEventsDict = DaysWithEvents()
                        var eventsError: ApiError?
                        
                        for (index, eventsResponse) in eventsArrays.enumerated() {
                            switch eventsResponse {
                            case .success(let events):
                                daysWithEventsDict[days[index]] = events
                                break
                            case .failure(let error):
                                eventsError = error
                            
                            }
                        }
                        
                        if (eventsError == nil){
                            return LoadDaysWithEventsResponse.success(daysWithEventsDict)
                        } else {
                           return LoadDaysWithEventsResponse.failure(eventsError!)
                        }
                    }
                    
                    
                    return daysWithEvents
                    
                case .failure(let daysError):
                    return Observable.just(LoadDaysWithEventsResponse.failure(daysError))
                }
                
            }
        
    }
    
    
    
    
}
