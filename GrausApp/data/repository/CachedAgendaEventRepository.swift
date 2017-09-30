 //
//  CachedAgendaEventRepository.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 8/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift

class CachedAgendaEventRepository: AgendaEventRepository {
    
    let cachedDatasource = AgendaEventCacheDatasource()
    
    override func loadDays() -> Observable<LoadDaysResponse> {
        return super.loadDays()
            .flatMap { loadDaysResponse -> Observable<LoadDaysResponse> in
                switch loadDaysResponse{
                case .success(_):
                    return Observable.just(loadDaysResponse)
                case .failure(let error):
                    print(error)
                    return self.cachedDatasource.loadDays()
                }
            }
            .catchError { error in
                return self.cachedDatasource.loadDays()
        }
    }
    
    override func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        return super.loadAgendaEvents(day: day)
    }
    
    override func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        return super.loadDaysWithEvents(day: day)
            .flatMap { loadDaysWithEventsResponse -> Observable<LoadDaysWithEventsResponse> in
                switch loadDaysWithEventsResponse{
                case .success(_):
                    return Observable.just(loadDaysWithEventsResponse)
                case .failure(let error):
                    print(error)
                    return self.cachedDatasource.loadDaysWithEvents(day: day)
                }
            }
        
    }
}
