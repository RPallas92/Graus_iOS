//
//  Agenda+Feedback.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 6/29/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxFeedback

struct AgendaListFeedback {
    
    //Reactions
    static func shouldLoadDataReaction(agendaDataSource: AgendaEventCloudDatasource) -> (Driver<AgendaListState>) -> Driver<AgendaListEvent> {
        
        let query:(AgendaListState) -> Bool?
            = { $0.shouldLoadData }
        
        let effects:(Bool) -> Driver<AgendaListEvent>
            = { shouldLoadDataEffects(shouldLoadData: $0, eventsDataSource: agendaDataSource) }
        
        return react(query: query, effects: effects)
    }
    
    static func selectedEventReaction(navigationController: UINavigationController?) -> (Driver<AgendaListState>) -> Driver<AgendaListEvent> {
        
        let query:(AgendaListState) -> AgendaEvent?
            = { $0.selectedEvent}
        
        let effects:(AgendaEvent) -> Driver<AgendaListEvent>
            = { selectedEventEffects(selectedEvent: $0, navigationController: navigationController)}
        
        return react(query:query, effects: effects)
    }
    
    static func loadEventsResponseReaction(refreshControl: UIRefreshControl) -> (Driver<AgendaListState>) -> Driver<AgendaListEvent>  {
        let query:(AgendaListState) -> Bool?
            = {
                $0.isRefreshed
        }
        let effects:(Bool) -> Driver<AgendaListEvent>
            = { refreshFinishedEffects(refreshHasFinished: $0, refreshControl: refreshControl)}
        
        return react(query:query, effects: effects)

    }
}



//Effects
fileprivate func shouldLoadDataEffects(shouldLoadData: Bool, eventsDataSource: AgendaEventCloudDatasource) -> Driver<AgendaListEvent>{
    if(shouldLoadData){
        return eventsDataSource.loadDaysWithEvents(day: Day.getToday())
            .asDriver(onErrorJustReturn: .failure(.offline))
            .map(AgendaListEvent.response)
    } else {
        return Driver.empty()
    }
}

fileprivate func selectedEventEffects(selectedEvent: AgendaEvent, navigationController: UINavigationController?) -> Driver<AgendaListEvent> {
    return showDetail(event: selectedEvent, navigationController: navigationController)
        .asDriver(onErrorJustReturn: AgendaListEvent.detailShowed())
}

fileprivate func refreshFinishedEffects(refreshHasFinished: Bool, refreshControl: UIRefreshControl) -> Driver<AgendaListEvent> {
    if refreshHasFinished {
        refreshControl.endRefreshing()
        return Driver.just(AgendaListEvent.refreshFinished())
    } else {
        return Driver.empty()
    }
    
}

//Helper funcs
fileprivate func showDetail(event:AgendaEvent, navigationController: UINavigationController?) -> Observable<AgendaListEvent>{
    if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "detail") as? AgendaDetailViewController {
        viewController.agendaEvent = event
        if let navigator = navigationController {
            navigator.pushViewController(viewController, animated: true)
        }
    }
    return Observable.just(AgendaListEvent.detailShowed())
}
