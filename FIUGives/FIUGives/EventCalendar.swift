//
//  EventCalendar.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/8/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit 

class EventCalendar {
    
    
    //MARK: properties
    static let shared = EventCalendar()
    var myCalendar: [Event]
    
    //MARK: initialization
    private init() {
        self.myCalendar = Array()
    }
    
    //MARK: methods
    func addEvent(newEvent: Event) {
        self.myCalendar.append(newEvent)
    }
    
    func totalEvents() -> Int {
        return self.myCalendar.count
    }
    
    
}
