//
//  AgendaEventRepository.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 8/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift

class AgendaEventRepository: AgendaEventRepositoryProtocol {
    
    var dataSource: AgendaEventDatasourceProtocol
    
    init(dataSource: AgendaEventDatasourceProtocol) {
        self.dataSource = dataSource
    }
    func loadDays() -> Observable<LoadDaysResponse> {
        return dataSource.loadDays()
    }
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse> {
        return dataSource.loadAgendaEvents(day: day)
    }
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse> {
        return dataSource.loadDaysWithEvents(day: day)
    }
    
}
