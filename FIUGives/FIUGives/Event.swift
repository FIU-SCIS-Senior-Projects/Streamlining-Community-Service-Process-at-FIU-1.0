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
    var eventStart: Date
    var eventEnd: Date
    var eventDuration = 0.0
    var eventAddress: Address
    var eventContactName: String
    var eventContactEmail: String
    var eventCapacity = 0
    var eventLatitude = 0.0
    var eventLongitude = 0.0
    var active = true
    var eventDate: EventDate
    
    var eventAttendants = [String]()
    
    //MARK: initialization
    init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: Date, eventEnd: Date, eventAddress: Address, eventContactName: String, eventContactEmail: String) {
        
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
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart))
        self.eventDate = EventDate.init(myEventDate: eventStart)
        
    }
     //init with capacity
    convenience init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: Date, eventEnd: Date, eventAddress: Address, eventContactName: String, eventContactEmail: String, eventCapacity: Int) {
    
        self.init(eventName: eventName, eventCategory: eventCategory, eventFlyerURL: eventFlyerURL, eventDescription: eventDescription, eventStart: eventStart, eventEnd: eventEnd, eventAddress:eventAddress, eventContactName: eventContactName, eventContactEmail: eventContactEmail)
    self.eventCapacity = eventCapacity
    }
    
    //update latitude
    func setLatitude (eventLatitude: Double) {
    self.eventLatitude = eventLatitude
    }
    
    //update longitude
    func setLongitude (eventLongitude: Double) {
        self.eventLongitude = eventLongitude
    }
    
    static func < (lhs: Event, rhs: Event) -> Bool {
        if (lhs.eventStart.compare(rhs.eventStart) == .orderedAscending) {
        return true
        }
        return false
    }
    
    //compare events for equality based on their start date & time
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.eventStart == rhs.eventStart
        
    }
    
    //compare 
    
    //returns the start date in the format "EEEE,   MMM d, yyyy" as a string
    func returnStartDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter.string(from: self.eventStart)
    }
    
    //returns the end date in the format "EEEE,   MMM d, yyyy" as a string
    func returnEndDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE,   MMM d, yyyy"
        return formatter.string(from: self.eventEnd)
    }
    
    //returns the start time in the format h:mm a" as a string
    func returnStartTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self.eventStart)
    }
    
    //returns the end time in the format h:mm a" as a string
    func returnEndTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter.string(from: self.eventEnd)
    }
    
    func dictionaryObject() -> Any {
        return [
            "eventName": eventName,
            "eventStart": returnStartDate(),
            "eventEnd": returnEndDate()
        ]
    }
    
    
    
    
    
    
    
    
    
    
    /* Add attendants to the eventAttendants array
    func addToEventAttendants(Attendant: String) {
        self.eventAttendants.append(Attendant)
    }
    
    // Remove attendant from the eventAttendants array
    func removeEventAttendant(Attendant: String) {
        if let index = eventAttendants.index(of: Attendant) {
            self.eventAttendants.remove(at: index)
        }
    }
    */
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
    
    func setEventStartDate(StartDate: Date) {
        self.eventStart = StartDate
    }
    
    func setEventEndDate(EndDate: Date) {
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
    
    func setEventCapacity(Capacity: Int) {
        self.eventCapacity = Capacity
    }
    
    // Format event start date
    
    // Format event end date
    
    
    
    
    
    
    
    deinit {
        
    }
    
}


