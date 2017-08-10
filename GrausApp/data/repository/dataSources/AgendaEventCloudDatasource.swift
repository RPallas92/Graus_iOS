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

class AgendaEventCloudDatasource: AgendaEventDatasourceProtocol {
    let cacheDatasource = AgendaEventCacheDatasource()
    
    func loadDays() -> Observable<LoadDaysResponse> {
        return URLSession.shared.loadDays().map(cacheDays)
    }
    
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        return URLSession.shared.loadAgendaEvents(day: day).map(cacheAgendaEvents)
    }
    
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        return URLSession.shared.loadDaysWithEvents(day: day).map(cacheDaysWithEvents)
    }
    
    //Cache functions
    private func cacheDays(loadDaysResponse: LoadDaysResponse) -> LoadDaysResponse {
        cacheDatasource.insertDays(daysResponse: loadDaysResponse)
        return loadDaysResponse
    }
    
    private func cacheAgendaEvents(loadAgendaEventsResponse: LoadAgendaEventsResponse) -> LoadAgendaEventsResponse {
        cacheDatasource.insertEventsFor(day: loadAgendaEventsResponse)
        return loadAgendaEventsResponse
    }
    
    private func cacheDaysWithEvents(loadDaysWithEventsResponse: LoadDaysWithEventsResponse) -> LoadDaysWithEventsResponse {
        switch loadDaysWithEventsResponse {
        case .success(_):
            cacheDatasource.insertDaysWithEvents(daysWithEventsResponse: loadDaysWithEventsResponse)
            break
        case .failure(_):
            break
        }
        return loadDaysWithEventsResponse
    }
}

extension URLSession {
    
    func loadDays() -> Observable<LoadDaysResponse> {
        let url = URL(string: "http://ejeadefiestas.ejeadigital.com/index.php/api/fiestas/dias_con_eventos/id/200/format/json")!
    
        return self
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .map(Day.parse)
            .catchErrorJustReturn(LoadDaysResponse.failure(.offline))
    }
    
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse>{
        let url = URL(string: "http://ejeadefiestas.ejeadigital.com/index.php/api/eventos/eventos_by_dia/id/200/dia/\(day.toString())/format/json")!
        
        return self
            .rx.response(request: URLRequest(url: url))
            .retry(3)
            .map(AgendaEvent.parse)
            .catchErrorJustReturn(LoadAgendaEventsResponse.failure(.offline))

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
            
            if let index = days.index(where: {$0 == nearestDay}) {
                return Array(days[index..<days.count])
            } else {
                return [nearestDay!]
            }
        }
        
        return loadDays()
            .flatMap { daysResponse -> Observable<LoadDaysWithEventsResponse> in
                
                switch daysResponse {
                case .success(let days):
                    let nearestRange = getNearDaysRange(days: days, day: day)
                    let eventsForEachDay = nearestRange.map { day in
                        return self.loadAgendaEvents(day: day)
                    }
                    
                    return Observable.zip(eventsForEachDay) { (eventsArrays: [LoadAgendaEventsResponse]) in
                        var daysWithEventsDict = DaysWithEvents()
                        var eventsError: ApiError?
                        
                        for (index, eventsResponse) in eventsArrays.enumerated() {
                            switch eventsResponse {
                            case .success(let events):
                                daysWithEventsDict[nearestRange[index]] = events
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
                    
                case .failure(let daysError):
                    return Observable.just(LoadDaysWithEventsResponse.failure(daysError))
                }
        }
        
    }
}
