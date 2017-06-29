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
    
    var tableViewDataSource: RxTableViewSectionedAnimatedDataSource<AgendaEventsSection>?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableViewDataSource = RxTableViewSectionedAnimatedDataSource<AgendaEventsSection>()

        agendaEventsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "event")
        
        
        func configureAgendEventCell(_: Int, agendaEvent: AgendaEvent, cell: UITableViewCell){
            cell.textLabel?.text = agendaEvent.name
        }
        
        tableViewDataSource.configureCell = { ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "Cell") ?? UITableViewCell(style: .default, reuseIdentifier: "event")
            cell.textLabel?.text = item.name
            
            return cell
        }
        
        tableViewDataSource.titleForHeaderInSection = { ds, index in
            return ds.sectionModels[index].header
        }
        
        
        self.tableViewDataSource = tableViewDataSource
        
        
        let triggerLoadData: (Driver<State>) -> Driver<Event> = { state in
            return state.flatMapLatest { state -> Driver<Event> in
                if state.shouldLoadData {
                    return Driver.empty()
                }
                
                return Driver.just(Event.startLoadingEvents())
            }
        }
        
        let bindUI: (Driver<State>) -> Driver<Event> = UI.bind() { state in (
            [
                state.map { AgendaEventsSection.fromAgendaEvents(daysWithEvents: $0.results) }.drive(self.agendaEventsTableView.rx.items(dataSource: tableViewDataSource)),
                state.map { $0.title }.drive(onNext: { self.navigationController!.navigationBar.topItem!.title = $0 }, onCompleted: nil, onDisposed: nil),
                ]
            ,[
                triggerLoadData(state)
            ]
            )}
        let today = Date.init()
        
        Driver.system(
            initialState: State.empty,
            reduce: State.reduce,
            feedback:
            // UI, user feedback
            bindUI,
            // NoUI, automatic feedback
            react(query: { $0.shouldLoadData }, effects: { resource in
                return self.agendaDataSource.loadDaysWithEvents(day: today)
                    .asDriver(onErrorJustReturn: .failure(.offline))
                    .map(Event.response)
            })
            )
            .drive()
            .disposed(by: disposeBag)
        
    }
    
}


//Boring CODE

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
    
    static func fromAgendaEvents(daysWithEvents: DaysWithEvents) -> [AgendaEventsSection] {
        
        let sortedDictArray = daysWithEvents.sorted(by: {
            $0.key.compare($1.key) == .orderedAscending
        })

        return sortedDictArray.map { tuple in
            return AgendaEventsSection(header: tuple.key.toString(), items: tuple.value)
        }
        
    }
}
