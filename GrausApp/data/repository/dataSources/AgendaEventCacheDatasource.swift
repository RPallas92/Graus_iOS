//
//  AgendaEventCacheDatasource.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 8/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift
import Cache

class AgendaEventCacheDatasource: AgendaEventDatasourceProtocol {
    
    let daysKey = "daysKey"
    let eventsForDayKey = "eventsForDayKey"
    let daysWithEventsKey = "daysWithEventsKey"
    
    let cache = HybridCache(name: "AgendaEvents")
    
    
    func loadDays() -> Observable<LoadDaysResponse> {
        let cachedDays: Array<Day>? = (cache.object(forKey: daysKey) as CacheArray<Day>?)?.elements
        if let days = cachedDays {
            let loadDaysResponse = LoadDaysResponse.success(days)
            return Observable.just(loadDaysResponse)
        }
        return Observable.just(LoadDaysResponse.failure(.internalError))
    }
    
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        let cachedAgendaEvents: Array<AgendaEvent>? = (cache.object(forKey: eventsForDayKey) as CacheArray<AgendaEvent>?)?.elements
        if let agendaEvents = cachedAgendaEvents {
            let loadAgendaEventsResponse = LoadAgendaEventsResponse.success(agendaEvents)
            return Observable.just(loadAgendaEventsResponse)
        }
        return Observable.just(LoadAgendaEventsResponse.failure(.internalError))
    }
    
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        let cachedJson: JSON? = cache.object(forKey: daysWithEventsKey)
        if let json = cachedJson {
            var daysWithEvents: DaysWithEvents
            
            switch json {
            case .dictionary(let jsonDict):
                daysWithEvents = DaysWithEvents.fromJsonDict(jsonDict: jsonDict)
            default:
                daysWithEvents = DaysWithEvents()
            }
            
            let loadDaysWithEventsResponse = LoadDaysWithEventsResponse.success(daysWithEvents)
            return Observable.just(loadDaysWithEventsResponse)
        }
        
        return Observable.just(LoadDaysWithEventsResponse.failure(.internalError))
    }
    
    func clearCache() {
        do {
            try cache.clear(keepingRootDirectory: false)
        } catch {
            print("Cannot clear cache")
        }
    }
    
    func insertDays(daysResponse: LoadDaysResponse) {
        switch daysResponse {
        case .success(let days):
            let object = CacheArray(elements: days)
            do {
                try cache.addObject(object, forKey: daysKey)
            } catch {
                print("Cannot insert days in cache")
            }
            break
        case.failure(_):
            clearCache()
            break
        }
    }
    
    func insertEventsFor(day agendaEventsResponse: LoadAgendaEventsResponse){
        switch agendaEventsResponse {
        case .success(let agendaEvents):
            let object = CacheArray(elements: agendaEvents)
            do {
                try cache.addObject(object, forKey: eventsForDayKey)
            } catch {
                print("Cannot insert days in cache")
            }
            break
        case.failure(_):
            clearCache()
            break
            
        }
    }
    
    func insertDaysWithEvents(daysWithEventsResponse: LoadDaysWithEventsResponse){
        switch daysWithEventsResponse {
        case .success(let daysWithEvents):
            do {
                let jsonDict = daysWithEvents.toJsonDict()
                try cache.addObject(JSON.dictionary(jsonDict), forKey: daysWithEventsKey)
            } catch {
                print("Cannot insert days in cache")
            }
            break
        case .failure(_):
            clearCache()
            break
        }
    }
    
    
    
}
