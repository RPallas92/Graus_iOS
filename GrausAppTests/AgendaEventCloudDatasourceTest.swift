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
    
    func testLoadDaysWithEvents() {
        let disposeBag = DisposeBag()
        
        let agendaEventCloudDataSource = AgendaEventCloudDatasource()
        
        let completed = self.expectation(description: "Days retrieved")
        let observable: Observable<LoadDaysWithEventsResponse> = agendaEventCloudDataSource.loadDaysWithEvents()
        
        observable.subscribe(onNext: { days in
            
            completed.fulfill()
        }).addDisposableTo(disposeBag)
        
        
        
        self.waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    
    
}
