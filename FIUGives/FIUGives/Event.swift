//
//  Event.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/4/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import CoreLocation

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
    
    
    init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventAddress: Address, eventContactName: String, eventContactEmail: String) {
        
        //initialize properties
        self.eventName = eventName
        self.eventCategory = eventCategory
        self.eventFlyerURL = eventFlyerURL
        self.eventDescription = eventDescription
        self.eventStart = Date()
        self.eventEnd = Date()
        self.eventAddress = eventAddress
        self.eventContactName = eventContactName
        self.eventContactEmail = eventContactEmail
        self.eventDate = EventDate.init(myEventDate: eventStart)
        //forward geocoding to set latitude & longitude properties of newly created event using GLGeocoder/check network connection prior
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventAddress.fullAddress(), completionHandler: {(placemarks, error) -> Void in
            if ((error) != nil) {
                print("Error")
            }
            if let placemark = placemarks?.first{
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.eventLatitude = coordinates.latitude
                self.eventLongitude = coordinates.longitude
            }
        })
    }
    convenience init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: Date, eventEnd: Date, eventAddress: Address, eventContactName: String, eventContactEmail: String) {
        self.init(eventName: eventName, eventCategory: eventCategory, eventFlyerURL: eventFlyerURL, eventDescription: eventDescription, eventAddress: eventAddress, eventContactName: eventContactName, eventContactEmail: eventContactEmail)
        //initialize properties
        self.eventStart = eventStart
        self.eventEnd = eventEnd
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart))
        self.eventDate = EventDate.init(myEventDate: eventStart)
    }
     //init with capacity
    convenience init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: Date, eventEnd: Date, eventAddress: Address, eventContactName: String, eventContactEmail: String, eventCapacity: Int) {
    
        self.init(eventName: eventName, eventCategory: eventCategory, eventFlyerURL: eventFlyerURL, eventDescription: eventDescription, eventStart: eventStart, eventEnd: eventEnd, eventAddress:eventAddress, eventContactName: eventContactName, eventContactEmail: eventContactEmail)
    self.eventCapacity = eventCapacity
    }
    
    //init from Firebase
    convenience init (eventName: String, eventCategory: String, eventFlyerURL: String, eventDescription: String, eventStart: String, eventEnd: String, eventAddress: Address, eventContactName: String, eventContactEmail: String, eventCapacity: Int) {
        self.init(eventName: eventName, eventCategory: eventCategory, eventFlyerURL: eventFlyerURL, eventDescription: eventDescription, eventAddress: eventAddress, eventContactName: eventContactName, eventContactEmail: eventContactEmail)
        //initialize properties
        self.eventStart = self.dateFromString(stringToDate: eventStart)
        self.eventEnd = self.dateFromString(stringToDate: eventEnd)
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart))
        self.eventDate = EventDate.init(myEventDate: self.eventStart)
        self.eventCapacity = eventCapacity
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
    
    
    
    
    
    
    
    
    
    func addToEventAttendants(Attendant: String) {
        self.eventAttendants.append(Attendant)
    }
    

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
    //returns the start date in the format "MMM d, yyyy h:mm a" as a string
    func returnStartDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter.string(from: self.eventStart)
    }
    //returns the end date in the format "MMM d, yyyy h:mm a" as a string
    func returnEndDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        return formatter.string(from: self.eventEnd)
    }
    
    func updateName (eventName: String) {
        self.eventName = eventName
    }
    func updateFlyerURL (eventFlyerURL: String) {
        self.eventFlyerURL = eventFlyerURL
    }
    func updateContactName (eventContactName: String) {
        self.eventContactName = eventContactName
    }
    func updateContactEmail (eventContactEmail: String) {
        self.eventContactEmail = eventContactEmail
    }
    func updateAddress (eventAddress: Address) {
        self.eventAddress = eventAddress
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(eventAddress.fullAddress(), completionHandler: {(placemarks, error) -> Void in
            if ((error) != nil) {
                print("Error")
            }
            if let placemark = placemarks?.first{
                let coordinates: CLLocationCoordinate2D = placemark.location!.coordinate
                self.eventLatitude = coordinates.latitude
                self.eventLongitude = coordinates.longitude
            }
        })
    }
    func updateCapacity (eventCapacity: Int) {
        self.eventCapacity = eventCapacity
    }
    func updateDescription (eventDescription: String) {
        self.eventDescription = eventDescription
    }
    func updateStartDate (eventStartDate: Date) {
        self.eventStart = eventStartDate
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart))
        EventCalendar.shared.sortValueForKey(key: self.eventDate)
        User.sharedInstance.userEventCreated.sort()
    }
    func updateEndDate (eventEndDate: Date) {
        self.eventEnd = eventEndDate
        self.eventDuration = (Double)(self.eventEnd.timeIntervalSince(self.eventStart))
    }
    func updateCategory (eventCategory: String) {
        self.eventCategory = eventCategory
    }
    func deactivateEvent() {
        self.active = false
    }
    func returnKey() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMdyyyy"
        let start = formatter.string(from: self.eventStart)
        return self.eventName+start
    }
    func stringFromDate (dateToString: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        return formatter.string(from: dateToString)
    }
    func dateFromString (stringToDate: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        formatter.timeZone = NSTimeZone.default
        return formatter.date(from: stringToDate)!
    }
    func setStartDateFromString (stringToDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        formatter.timeZone = NSTimeZone.default
        self.eventStart = formatter.date(from: stringToDate)!
    }
    func setEndDateFromString (stringToDate: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        formatter.timeZone = NSTimeZone.default
        self.eventEnd = formatter.date(from: stringToDate)!
    }
    
    
    func keyDictionaryObject() -> Any {
        return [
            "Key": self.returnKey()
        ]
    }
    
    
    
    
    func dictionaryObject() -> Any {
        return [
            "eventName": self.eventName,
            "eventCategory": self.eventCategory,
            "eventFlyerURL": self.eventFlyerURL,
            "eventDescription": self.eventDescription,
            "eventStart": self.stringFromDate(dateToString: self.eventStart),
            "eventEnd": self.stringFromDate(dateToString: self.eventEnd),
            "eventStreet": self.eventAddress.street,
            "eventCity": self.eventAddress.city,
            "eventState": self.eventAddress.state,
            "eventZip": self.eventAddress.zip,
            "eventContactName": self.eventContactName,
            "eventContactEmail": self.eventContactEmail,
            "eventCapacity": self.eventCapacity.description
        ]
    }
    
       deinit {
        
    }
    
}


