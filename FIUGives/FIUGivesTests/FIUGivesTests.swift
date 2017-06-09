//
//  FIUGivesTests.swift
//  FIUGivesTests
//
//  Created by Kathryn Bello on 5/31/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

//
//  FIUgivesTests.swift
//  FIUgivesTests
//
//  Created by Katya Gumnova on 5/29/17.
//  Copyright © 2017 Katya Gumnova. All rights reserved.
//

import XCTest
@testable import FIUGives

class FIUgivesTests: XCTestCase {
    
    //    override func setUp() {
    //        super.setUp()
    //        // Put setup code here. This method is called before the invocation of each test method in the class.
    //    }
    //
    //    override func tearDown() {
    //        // Put teardown code here. This method is called after the invocation of each test method in the class.
    //        super.tearDown()
    //    }
    //
    //    func testExample() {
    //        // This is an example of a functional test case.
    //        // Use XCTAssert and related functions to verify your tests produce the correct results.
    //    }
    //
    //    func testPerformanceExample() {
    //        // This is an example of a performance test case.
    //        self.measure {
    //            // Put the code you want to measure the time of here.
    //        }
    //    }
    
    //MARK: Event Class tests
    //Confirm that the Event initializer returns an Event object when passed valid parameters
    func testEventInitializerSucceeds() {
        let newEventOne = Event.init(eventName: "Hospital event", eventCategory: "Hospitals", eventFlyerURL: "", eventDescription: "", eventStart: NSDate(), eventEnd: NSDate(), eventLocationName: "Aventura hospital", eventClubs:"", eventContactName: "Allen", eventContactEmail: "allen@email", eventRSVPEnabled: true)
        XCTAssertNotNil(newEventOne)
    }
    //Confirm that the Event initializer returns nil when passed an empty eventName
    func testEventInitializerFails() {
        let emptyNameEvent = Event.init(eventName: "", eventCategory: "", eventFlyerURL: "", eventDescription: "", eventStart: NSDate(), eventEnd: NSDate(), eventLocationName: "Aventura hospital", eventClubs: "", eventContactName: "Allen", eventContactEmail: "allen@email", eventRSVPEnabled: true)
        XCTAssertNil(emptyNameEvent)
    }
    

}
