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
    var myCalendar: [EventDate:[Event]]
    
    
    //MARK: initialization
    private init() {
        self.myCalendar = [EventDate:[Event]]()
        
    }
    
    //MARK: methods
    func addEvent(newEvent: Event) {
        if self.myCalendar.keys.contains(newEvent.eventDate) {
            self.myCalendar[newEvent.eventDate]?.append(newEvent)
            self.myCalendar[newEvent.eventDate]?.sort()
        }
        else {
            self.myCalendar[newEvent.eventDate] = [newEvent]
        }
    }
    
    func sortValueForKey(key: EventDate) {
        self.myCalendar[key]?.sort()
    }
    
    func totalEvents() -> Int {
        return self.myCalendar.count
    }
    

    
  
    
    
    
    
}
