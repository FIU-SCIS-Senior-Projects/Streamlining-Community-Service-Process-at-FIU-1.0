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
    var userRsvpEvents: [Event]
    var userEventCreated: [Event]
    
    //MARK: Initialization
    private init() {
        //initialize properties
        self.userFirstName = String()
        self.userLastName = String()
        self.userDOB = String()
        self.userLocation = String()
        self.userPhoneNumber = String()
        self.userRsvpEvents = Array()
        self.userEventCreated = Array()
    }
    
    func getUserFullName() -> String {
        return "\(userFirstName) \(userLastName)"
    }
    
    func addToUserEventCreated(Event: Event) {
        self.userEventCreated.append(Event)
        self.userEventCreated.sort()
    }
    
    func addToUserRsvpEvents(Event: Event) {
        userRsvpEvents.append(Event)
    }
    
    func dictionaryObject() -> Any {
        return [
            "Firstname": userFirstName,
            "Lastname": userLastName,
            "DOB": userDOB,
            "Location": userLocation,
            "Phone": userPhoneNumber
        ]
    }
    
}
