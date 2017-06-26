//
//  AgendaEventCloudDatasource+Test.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import XCTest
import RxSwift



class AgendaEventCloudDatasourceTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadDays() {
        let disposeBag = DisposeBag()
        
        let agendaEventCloudDataSource = AgendaEventCloudDatasource()
        
        let completed = self.expectation(description: "Days retrieved")
        let observable: Observable<LoadDaysResponse> = agendaEventCloudDataSource.loadDays()
        
        observable.subscribe(onNext: { days in
            
            completed.fulfill()
        }).addDisposableTo(disposeBag)
        
        
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testLoadAgendaEvents() {
        let disposeBag = DisposeBag()
        
        let agendaEventCloudDataSource = AgendaEventCloudDatasource()
        let dayWithEvents = Date.init(timeIntervalSinceReferenceDate: 518738400.0)
        
        let completed = self.expectation(description: "Events retrieved for day")
        let observable: Observable<LoadAgendaEventsResponse> = agendaEventCloudDataSource.loadAgendaEvents(day: dayWithEvents)
        
        observable.subscribe(onNext: { events in
            
            completed.fulfill()
        }).addDisposableTo(disposeBag)
        
        
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    
    
    func testLoadDaysWithEvents(){
        let disposeBag = DisposeBag()
        
        let agendaEventCloudDataSource = AgendaEventCloudDatasource()
        let dayWithEvents = Date.init(timeIntervalSinceReferenceDate: 518738400.0)
        
        let completed = self.expectation(description: "Events retrieved for day")
        let observable: Observable<LoadDaysWithEventsResponse> = agendaEventCloudDataSource.loadDaysWithEvents(day: dayWithEvents)
        
        observable.subscribe(onNext: { events in
            
            completed.fulfill()
        }).addDisposableTo(disposeBag)
        
        
        
        self.waitForExpectations(timeout: 10, handler: nil)
    }
    
    
}
