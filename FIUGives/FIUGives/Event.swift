//
//  Event.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/4/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class Event: Comparable {
    
    //MARK: properties
    var eventName: String
    var eventCategory: String
    //URL for an event is an optional
    var eventFlyerURL: String
    //event discription is an optional
    var eventDescription: String
    var eventStart: NSDate
    var eventEnd: NSDate
    var eventDuration = 0.0
    var eventType: String
    var eventLocationName: String
    //event clubs is an optional
    var eventClubs: String
    var eventContactName: String
    var eventContactEmail: String
    var eventRSVPEnabled = true
    var eventCapacity = 0
    
    //array to hold the names of event attendants
    var eventAttendants = [String]()
    
    //MARK: initialization
    init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: NSDate, eventEnd: NSDate, eventLocationName: String, eventClubs: String, eventContactName: String, eventContactEmail: String, eventRSVPEnabled: Bool) {
        
        //initialize properties
        self.eventName = eventName
        self.eventCategory = eventCategory
        self.eventFlyerURL = eventFlyerURL
        self.eventDescription = eventDescription
        self.eventStart = eventStart
        self.eventEnd = eventEnd
        self.eventType = "Volunteering"
        self.eventLocationName = eventLocationName
        self.eventClubs = eventClubs
        self.eventContactName = eventContactName
        self.eventContactEmail = eventContactEmail
        self.eventRSVPEnabled = eventRSVPEnabled
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart as Date))
        
    }
     //init with capacity
    convenience init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: NSDate, eventEnd: NSDate, eventLocationName: String, eventClubs: String, eventContactName: String, eventContactEmail: String, eventRSVPEnabled: Bool, eventCapacity: Int) {
    
    self.init(eventName: eventName, eventCategory: eventCategory, eventFlyerURL: eventFlyerURL, eventDescription: eventDescription, eventStart: eventStart, eventEnd: eventEnd, eventLocationName: eventLocationName, eventClubs: eventClubs, eventContactName: eventContactName, eventContactEmail: eventContactEmail, eventRSVPEnabled: eventRSVPEnabled)
    self.eventCapacity = eventCapacity
    }
        

    
    
    
    //function to access eventStart property
    func getStartDate() -> NSDate {
        return self.eventStart
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        if (lhs.getStartDate().compare(rhs.getStartDate() as Date) == .orderedAscending) {
        return true
        }
        return false
    }
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.getStartDate().isEqual(to: rhs.getStartDate() as Date)
        
    }
    
    
    //add attendants to the eventAttendants array
    
    //remove attendant from the eventAttendants array
    
    // delete event method
    
    // 
    
    //update event information
    
    //format event start date
    
    //format event end date
    
    
    
    
    
    
    
    deinit {
        
    }
    
}


