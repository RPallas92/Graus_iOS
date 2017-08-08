//
//  AgendaEventDatasource.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 8/7/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift

protocol AgendaEventDatasourceProtocol {
    func loadDays() -> Observable<LoadDaysResponse>
    func loadAgendaEvents(day: Day) -> Observable<LoadAgendaEventsResponse>
    func loadDaysWithEvents(day: Day) -> Observable<LoadDaysWithEventsResponse>
}
