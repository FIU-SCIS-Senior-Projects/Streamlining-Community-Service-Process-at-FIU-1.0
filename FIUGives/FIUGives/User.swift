//
//  User.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/9/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class User {
    
    //MARK: properties
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
    
    //MARK: initialization
    init?(userName: String, userAbout: String?, userInterests: String?, userOrganizations: String?, userYear: String?, userTrack: String?, userPhone: String?, userEmail: String, userLinkedin: String?, userFacebook: String?, userTwitter: String?) {
        //initialization should fail if no eventName/eventCategory/eventLocationName/eventContactName/eventContactEmail
        if userName.isEmpty || userEmail.isEmpty {
            return nil
        }
    
    //initialize properties
    self.userName = userName
    self.userAbout = userAbout
    self.userInterests = userInterests
    self.userOrganizations = userOrganizations
    self.userYear = userYear
    self.userTrack = userTrack
    self.userPhone = userPhone
    self.userEmail = userEmail
    self.userLinkedin = userLinkedin
    self.userFacebook = userFacebook
    self.userTwitter = userTwitter
    
    }
    
    
    //get properties
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
    
    //set properties
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
}

