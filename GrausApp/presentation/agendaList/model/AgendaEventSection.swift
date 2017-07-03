//
//  AgendaEventSection.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 7/1/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxDataSources

struct AgendaEventsSection {
    var header: String
    var items: [AgendaEvent]
}

extension AgendaEventsSection : AnimatableSectionModelType {
    typealias Item = AgendaEvent
    
    var identity: String {
        return header
    }
    
    init(original: AgendaEventsSection, items: [Item]) {
        self = original
        self.items = items
    }
}
