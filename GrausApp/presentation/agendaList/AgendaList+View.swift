//
//  FirstViewController.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 4/8/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxFeedback
import RxDataSources


class AgendaViewController: UIViewController {
    
    @IBOutlet var agendaEventsTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    private let agendaDataSource = AgendaEventCloudDatasource()
    private let tableViewDataSource = RxTableViewSectionedAnimatedDataSource<AgendaEventsSection>()


    override func viewDidLoad() {
        super.viewDidLoad()

        initTableView()
        
        
        let bindUI: (Driver<AgendaListState>) -> Driver<AgendaListEvent> = UI.bind(self) { me, state in
            let subscriptions = [
                state.map { AgendaEventsSection.fromAgendaEvents(daysWithEvents: $0.results) }.drive(me.agendaEventsTableView.rx.items(dataSource: me.tableViewDataSource))
            ]
            let events = [
                me.agendaEventsTableView.rx.itemSelected.asDriver().map { me.tableViewDataSource[$0] }.map(AgendaListEvent.itemSelected)
            ]
            return UI.Bindings(subscriptions: subscriptions, events: events)
        }
        
        Driver.system(
            initialState:
                AgendaListState.empty,
            reduce:
                AgendaListState.reduce,
            feedback:
                // UI, user feedback
                bindUI,
                // NoUI, automatic feedback
                AgendaListFeedback.shouldLoadDataReaction(agendaDataSource: self.agendaDataSource),
                AgendaListFeedback.selectedEventReaction(navigationController: navigationController)
            )
        .drive()
        .disposed(by: disposeBag)
        
    }
    
    
    func initTableView(){
        agendaEventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "event")

        tableViewDataSource.configureCell = { dataSource, tableView, indexPath, agendaEvent in
            let cell = tableView.dequeueReusableCell(withIdentifier: "agendaEvent") as! AgendaEventCell
            cell.event = agendaEvent
            return cell
        }
        
        tableViewDataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
    }
}
