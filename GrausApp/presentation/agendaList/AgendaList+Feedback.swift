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
    
    static func isLoadingDataReaction(shouldLoadData: Bool, eventsDataSource: AgendaEventCloudDatasource) -> Driver<AgendaListEvent>{
        if(shouldLoadData){
            return eventsDataSource.loadDaysWithEvents(day: Day.getToday())
                .asDriver(onErrorJustReturn: .failure(.offline))
                .map(AgendaListEvent.response)
        } else {
            return Driver.empty()
        }
    }
    
    
    static func itemSelectedReaction(selectedEvent: AgendaEvent, navigationController: UINavigationController?) -> Driver<AgendaListEvent> {
        return showDetail(event: selectedEvent, navigationController: navigationController)
            .asDriver(onErrorJustReturn: AgendaListEvent.detailShowed())
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
