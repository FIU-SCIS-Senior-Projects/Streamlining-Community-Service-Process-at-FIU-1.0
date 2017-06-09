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
    var userLinkedIn: String?
    var userFacebook: String?
    var userTwitter: String?
    
    //MARK: initialization
    init?(userName: String, userAbout: String?, userInterests: String?, userOrganizations: String?, userYear: String?, userTrack: String?, userPhone: String?, userEmail: String, userLinkedIn: String?, userFacebook: String?, userTwitter: String?) {
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
    self.userLinkedIn = userLinkedIn
    self.userFacebook = userFacebook
    self.userTwitter = userTwitter
    
    }
    
}

