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
    // var userPassword: String
    var userAbout: String
    var userPreferences: String
    var userPhone: String
    // var userEmail: String
    var userOccupation: String
    var userRsvpEvents: [Event]
    var userEventCreated: [Event]
    
    //MARK: Initialization
    private init() {
        //initialize properties
        self.userFirstName = String()
        self.userLastName = String()
        // self.userPassword = String()
        self.userAbout = String()
        self.userPreferences = String()
        self.userPhone = String()
        // self.userEmail = String()
        self.userOccupation = String()
        self.userRsvpEvents = Array()
        self.userEventCreated = Array()
    }
    
    func getUserFullName(First: String, Last: String) -> String {
        return "\(userFirstName) \(userLastName)"
    }
    
    func addToUserEventCreated(Event: Event) {
        userEventCreated.append(Event)
    }
    
    func addToUserRsvpEvents(Event: Event) {
        userRsvpEvents.append(Event)
    }
    
    func dictionaryObject() -> Any {
        return [
            "Firstname": userFirstName,
            "Lastname": userLastName,
            "Occupation": userOccupation,
            "About": userAbout,
            "Phone": userPhone
        ]
    }
    
}
