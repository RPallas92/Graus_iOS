//
//  FirstViewController.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 4/8/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit


fileprivate struct State {
    var results: [AgendaEvent]
    var lastError: ApiError?
    var shouldLoadData = true
}

fileprivate enum Event {
    case startLoadingEvents()
    case response(LoadAgendaEventsResponse)
}


// transitions
extension State {
    static var empty: State {
        return State( results: [], lastError: nil, shouldLoadData: true)
    }
    static func reduce(state: State, event: Event) -> State {
        switch event {
        case .startLoadingEvents():
            var result = state
            result.shouldLoadData = true
            return result
        case .response(.success(let response)):
            var result = state
            result.results += response
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

class AgendaViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

