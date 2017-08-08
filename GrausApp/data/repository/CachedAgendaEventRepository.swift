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
    
    override func loadDays() -> Observable<LoadDaysResponse> {
        return super.loadDays()
    }
    
    override func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        return super.loadAgendaEvents(day: day)
    }
    
    override func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        return super.loadDaysWithEvents(day: day)
    }
}
