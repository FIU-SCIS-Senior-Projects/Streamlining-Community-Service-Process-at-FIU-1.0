//
//  User.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/9/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

//MARK: - Singleton
class User {
    //MARK: Shared Instance
    static let sharedInstance = User()
    
    //MARK: Properties
    var userFirstName: String
    var userLastName: String
    // var userPassword: String
    var userAbout: String?
    var userInterests: String?
    var userPhone: String?
    var userEmail: String
    var userLinkedin: String?
    var userFacebook: String?
    var userTwitter: String?
    var userEventsCreated = [Event]()
    var userEventsRsvp = [Event]()
    
    
    //MARK: Initialization
    private init() {
        //initialize properties
        self.userFirstName = String()
        self.userLastName = String()
        self.userAbout = String()
        self.userInterests = String()
        self.userPhone = String()
        self.userEmail = String()
        self.userLinkedin = String()
        self.userFacebook = String()
        self.userTwitter = String()
        self.userEventsRsvp = Array()
        self.userEventsCreated = Array()
    }
    
    //MARK: Set Methods
    func setUserFirstName(FirstName: String) {
        self.userFirstName = FirstName
    }
    
    func setUserLastName(LastName: String) {
        self.userLastName = LastName
    }
    
    func setUserAbout(About: String) {
        self.userAbout = About
    }
    
    func setUserInterests(Interests: String) {
        self.userInterests = Interests
    }
    
    func setUserPhone(Phone: String) {
        self.userPhone = Phone
    }
    
    func setUserEmail(Email: String) {
        self.userEmail = Email
    }
    
    func setUserLinkedin(Linkedin: String) {
        self.userLinkedin = Linkedin
    }
    
    func setUserTwitter(Twitter: String) {
        self.userTwitter = Twitter
    }
    
    func setUserFacebook(Facebook: String) {
        self.userFacebook = Facebook
    }

    func addToUserEventCreated(Event: Event) {
        self.userEventsCreated.append(Event)
    }
    
    func addToUserEventRsvp(Event: Event) {
        self.userEventsRsvp.append(Event)
    }
    
    func getUserFullName(First: String, Last: String) -> String {
        return "\(userFirstName) \(userLastName)"
    }
    
}
