//
//  AgendaEvent+State.swift
//  GrausApp
//
//  Created by Ricardo Pallás on 03/07/2017.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

struct AgendaDetailState {
    var event: AgendaEvent?
    var shouldLoadEvent = true
}

enum AgendaDetailEvent {
    case startLoadingEvent()
    case response(AgendaEvent)
}


// transitions
extension AgendaDetailState {
    static var empty: AgendaDetailState {
        return AgendaDetailState(event: nil, shouldLoadEvent: true)
    }
    static func reduce(state: AgendaDetailState, event: AgendaDetailEvent) -> AgendaDetailState {
        switch event {
        case .startLoadingEvent():
            var result = state
            result.shouldLoadEvent = false
            result.event = nil
            return result
        case .response(let agendaEvent):
            var result = state
            result.event = agendaEvent
            result.shouldLoadEvent = false
            return result

        }
    }
}
