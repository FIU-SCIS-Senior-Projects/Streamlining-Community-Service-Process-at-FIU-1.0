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
    var eventFlyerURL: String
    var eventDescription: String
    var eventStart: NSDate
    var eventEnd: NSDate
    var eventDuration = 0.0
    var eventAddress: Address
    var eventContactName: String
    var eventContactEmail: String
    var eventRSVPEnabled = true
    var eventCapacity = 0
    var eventLatitude: Double?
    var eventLongitude: Double?
    
    var eventAttendants = [String]()
    
    //MARK: initialization
    init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: NSDate, eventEnd: NSDate, eventAddress: Address, eventContactName: String, eventContactEmail: String, eventRSVPEnabled: Bool) {
        
        //initialize properties
        self.eventName = eventName
        self.eventCategory = eventCategory
        self.eventFlyerURL = eventFlyerURL
        self.eventDescription = eventDescription
        self.eventStart = eventStart
        self.eventEnd = eventEnd
        //self.eventType = "Volunteering"
        self.eventAddress = eventAddress
        //self.eventClubs = eventClubs
        self.eventContactName = eventContactName
        self.eventContactEmail = eventContactEmail
        self.eventRSVPEnabled = eventRSVPEnabled
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart as Date))
        
    }
     //init with capacity
    convenience init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: NSDate, eventEnd: NSDate, eventAddress: Address, eventContactName: String, eventContactEmail: String, eventRSVPEnabled: Bool, eventCapacity: Int) {
    
        self.init(eventName: eventName, eventCategory: eventCategory, eventFlyerURL: eventFlyerURL, eventDescription: eventDescription, eventStart: eventStart, eventEnd: eventEnd, eventAddress:eventAddress, eventContactName: eventContactName, eventContactEmail: eventContactEmail, eventRSVPEnabled: eventRSVPEnabled)
    self.eventCapacity = eventCapacity
    }
        

    
    
    
    // Function to access eventStart property
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
    
    
    // Add attendants to the eventAttendants array
    func addToEventAttendants(Attendant: String) {
        self.eventAttendants.append(Attendant)
    }
    
    // Remove attendant from the eventAttendants array
    func removeEventAttendant(Attendant: String) {
        if let index = eventAttendants.index(of: Attendant) {
            self.eventAttendants.remove(at: index)
        }
    }
    
    // Delete event method
    
    
    // Update event information
    func setEventName(Name: String) {
        self.eventName = Name
    }
    
    func setEventCategory(Category: String) {
        self.eventName = Category
    }
    
    func setEventFlyerURL(Flyer: String) {
        self.eventFlyerURL = Flyer
    }
    
    func setEventDescription(Description: String) {
        self.eventDescription = Description
    }
    
    func setEventStartDate(StartDate: NSDate) {
        self.eventStart = StartDate
    }
    
    func setEventEndDate(EndDate: NSDate) {
        self.eventEnd = EndDate
    }
    
    func setEventAddress(EventAddress: Address) {
        self.eventAddress = EventAddress
    }
    
    func setEventContactName(ContactName: String) {
        self.eventContactName = ContactName
    }
    
    func setEventContactEmail(ContactEmail: String) {
        self.eventContactEmail = ContactEmail
    }
    
    func setEventRSVP(RsvpEnable: Bool) {
        self.eventRSVPEnabled = RsvpEnable
    }
    
    func setEventCapacity(Capacity: Int) {
        self.eventCapacity = Capacity
    }
    
    // Format event start date
    
    // Format event end date
    
    
    
    
    
    
    
    deinit {
        
    }
    
}


