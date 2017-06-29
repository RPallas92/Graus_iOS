//
//  Agenda+State.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 6/29/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

struct State {
    var results: DaysWithEvents
    var lastError: ApiError?
    var shouldLoadData = true
    var title = "Agenda"
}

enum Event {
    case startLoadingEvents()
    case response(LoadDaysWithEventsResponse)
}


// transitions
extension State {
    static var empty: State {
        return State( results: DaysWithEvents(), lastError: nil, shouldLoadData: true, title: "Agenda")
    }
    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .startLoadingEvents():
            var result = state
            result.shouldLoadData = true
            return result
        case .response(.success(let response)):
            var result = state
            result.results = response
            result.lastError = nil
            return result
        case .response(.failure(let error)):
            var result = state
            result.lastError = error
            return result
        }
    }
}

// queries
extension State {
    
}
