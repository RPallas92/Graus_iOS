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
        return URLSession.shared.loadDays()
    }
    
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        return URLSession.shared.loadAgendaEvents(day: day)
    }
    
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        return URLSession.shared.loadDaysWithEvents(day: day)
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
                //try cache.addObject(JSON.dictionary(daysWithEvents), forKey: daysWithEventsKey)
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
