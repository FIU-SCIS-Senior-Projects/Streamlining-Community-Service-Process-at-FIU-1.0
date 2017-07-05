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
    var userPassword: String
    var userAbout: String?
    var userPreferences: String?
    var userPhone: String?
    var userEmail: String
    var userRsvpEvents: [Event]
    var userEventCreated: [Event]
    
    //MARK: Initialization
    private init() {
        //initialize properties
        self.userFirstName = String()
        self.userLastName = String()
        self.userPassword = String()
        self.userAbout = String()
        self.userPreferences = String()
        self.userPhone = String()
        self.userEmail = String()
        self.userRsvpEvents = Array()
        self.userEventCreated = Array()
    }
    
    //MARK: Set Methods
    func setUserFirstName(FirstName: String) {
        self.userFirstName = FirstName
    }
    
    func setUserLastName(LastName: String) {
        self.userLastName = LastName
    }
    
    func setUserPassword(Password: String) {
        self.userPassword = Password
    }
    
    func setUserAbout(About: String) {
        self.userAbout = About
    }
    
    func setUserInterests(Preferences: String) {
        self.userPreferences = Preferences
    }
    
    func setUserPhone(Phone: String) {
        self.userPhone = Phone
    }
    
    func setUserEmail(Email: String) {
        self.userEmail = Email
    }
    
    func addToUserEventCreated(Event: Event) {
        userEventCreated.append(Event)
    }
    
    func addToUserRsvpEvents(Event: Event) {
        userRsvpEvents.append(Event)
    }
    
    func getUserFullName(First: String, Last: String) -> String {
        return "\(userFirstName) \(userLastName)"
    }
    
}
