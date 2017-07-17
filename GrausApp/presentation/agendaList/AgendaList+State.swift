//
//  Agenda+State.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 6/29/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

struct AgendaListState {
    var results: DaysWithEvents
    var lastError: ApiError?
    var shouldLoadData = true
    var selectedEvent: AgendaEvent?
}

enum AgendaListEvent {
    case response(LoadDaysWithEventsResponse)
    case itemSelected(AgendaEvent)
    case detailShowed()
}


// transitions
extension AgendaListState {
    static var empty: AgendaListState {
        return AgendaListState( results: DaysWithEvents(), lastError: nil, shouldLoadData: true, selectedEvent: nil)
    }
    static func reduce(state: AgendaListState, event: AgendaListEvent) -> AgendaListState {
        switch event {
        case .response(.success(let response)):
            var result = state
            result.results = response
            result.lastError = nil
            result.shouldLoadData = false
            result.selectedEvent = nil
            return result
        case .response(.failure(let error)):
            var result = state
            result.lastError = error
            result.shouldLoadData = false
            result.selectedEvent = nil
            return result
        case .itemSelected(let agendaEvent):
            var result = state
            result.selectedEvent = agendaEvent
            return result
        case .detailShowed():
            var result = state
            result.selectedEvent = nil
            return result
        }
    }
}

// queries - rpallas: I understand this as computed values that UI elements query to the State
extension AgendaListState {
    
}
