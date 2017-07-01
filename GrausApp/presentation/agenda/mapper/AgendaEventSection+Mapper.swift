//
//  AgendaEventSection+Mapper.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 7/1/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation


extension AgendaEventsSection {
    static func fromAgendaEvents(daysWithEvents: DaysWithEvents) -> [AgendaEventsSection] {
        
        let sortedDictArray = daysWithEvents.sorted(by: {
            $0.key.compare($1.key) == .orderedAscending
        })
        
        return sortedDictArray.map { tuple in
            return AgendaEventsSection(header: tuple.key.toString(), items: tuple.value)
        }
        
    }
}
