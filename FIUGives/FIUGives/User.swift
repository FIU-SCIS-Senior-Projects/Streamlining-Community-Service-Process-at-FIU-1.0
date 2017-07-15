//
//  User.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/9/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

//MARK: - Singleton
class User {
    //MARK: Shared Instance
    static let sharedInstance = User()
    
    //MARK: Properties
    var userFirstName: String
    var userLastName: String
    var userDOB: String
    var userLocation: String
    var userPhoneNumber: String
    var userOccupation: String
    var userRsvpEvents: [EventDate:[Event]]
    var userEventCreated: [Event]
    
    //MARK: Initialization
    private init() {
        //initialize properties
        self.userFirstName = String()
        self.userLastName = String()
        self.userDOB = String()
        self.userLocation = String()
        self.userPhoneNumber = String()
        self.userOccupation = String()
        self.userRsvpEvents = [EventDate:[Event]]()
        self.userEventCreated = Array()
    }
    
    func getUserFullName() -> String {
        return "\(userFirstName) \(userLastName)"
    }
    
    func addRsvpEvent(newEvent: Event) {
        if self.userRsvpEvents.keys.contains(newEvent.eventDate) {
            self.userRsvpEvents[newEvent.eventDate]?.append(newEvent)
            self.userRsvpEvents[newEvent.eventDate]?.sort()
        }
        else {
            self.userRsvpEvents[newEvent.eventDate] = [newEvent]
        }
    }
    
    func addToUserEventCreated(Event: Event) {
        userEventCreated.append(Event)
    }
    
    func setUserFirstName(First: String) {
        userFirstName = First
    }
    
    func setUserLastName(Last: String) {
        userLastName = Last
    }
    
    func setUserPhoneNumber(Phone: String) {
        userPhoneNumber = Phone
    }
    
    func setUserLocation(Location: String) {
        userLocation = Location
    }
    
    func setUserDateOfBirth(Birth: String) {
        userDOB = Birth
    }
    
    func setUserOccupation(Occupation: String) {
        userOccupation = Occupation
    }
    
    func dictionaryObject() -> Any {
        return [
            "Firstname": userFirstName,
            "Lastname": userLastName,
            "DOB": userDOB,
            "Location": userLocation,
            "Phone": userPhoneNumber,
            "Occupation": userOccupation
        ]
    }
    
}
