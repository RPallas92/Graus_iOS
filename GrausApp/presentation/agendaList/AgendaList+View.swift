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
                //triggerLoadData(state),
                me.agendaEventsTableView.rx.itemSelected.asDriver().map { me.tableViewDataSource[$0] }.map(AgendaListEvent.itemSelected)
            ]
            return UI.Bindings(subscriptions: subscriptions, events: events)
        }
        
        Driver.system(
            initialState: AgendaListState.empty,
            reduce: AgendaListState.reduce,
            feedback:
            // UI, user feedback
            bindUI,
            // NoUI, automatic feedback
            react(query: { $0.shouldLoadData }, effects: {
                AgendaListFeedback.isLoadingDataReaction(shouldLoadData: $0, eventsDataSource: self.agendaDataSource)
            }),
            react(query: { $0.selectedEvent}, effects: { selectedEvent in
                AgendaListFeedback.itemSelectedReaction(selectedEvent: selectedEvent, navigationController: self.navigationController)
            })
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
