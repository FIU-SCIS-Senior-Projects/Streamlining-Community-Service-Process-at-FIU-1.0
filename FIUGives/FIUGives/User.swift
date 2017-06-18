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
    var userName: String
    var userAbout: String?
    var userInterests: String?
    var userOrganizations: String?
    var userYear: String?
    var userTrack: String?
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
        self.userName = String()
        self.userAbout = String()
        self.userInterests = String()
        self.userOrganizations = String()
        self.userYear = String()
        self.userTrack = String()
        self.userPhone = String()
        self.userEmail = String()
        self.userLinkedin = String()
        self.userFacebook = String()
        self.userTwitter = String()
        self.userEventsCreated = Array()
        self.userEventsRsvp = Array()
    }
    
    //MARK: Get Methods
    func getUserName() -> String {
        return userName
    }
    
    func getUserAbout() -> String? {
        return userAbout
    }
    
    func getUserInterests() -> String? {
        return userInterests
    }
    
    func getUserOrganizations() -> String? {
        return userOrganizations
    }
    
    func getUserYear() -> String? {
        return userYear
    }
    
    func getUserTrack() -> String? {
        return userTrack
    }
    
    func getUserPhone() -> String? {
        return userPhone
    }
    
    func getUserEmail() -> String {
        return userEmail
    }
    
    func getUserLinkedIn() -> String? {
        return userLinkedin
    }
    
    func getUserTwitter() -> String? {
        return userTwitter
    }
    
    func getUserFacebook() -> String? {
        return userFacebook
    }
    
    func getUserEventsCreated() -> Array<Event> {
        return userEventsCreated
    }
    
    func getUserEventsRSVP() -> Array<Event> {
        return userEventsRsvp
    }
    
    //MARK: Set Methods
    func setUserName(Name: String) {
        self.userName = Name
    }
    
    func setUserAbout(About: String) {
        self.userAbout = About
    }
    
    func setUserInterests(Interests: String) {
        self.userInterests = Interests
    }
    
    func setUserOrganizations(Organizations: String) {
        self.userOrganizations = Organizations
    }
    
    func setUserYear(Year: String) {
        self.userYear = Year
    }
    
    func setUserTrack(Track: String) {
        self.userTrack = Track
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
    
}
