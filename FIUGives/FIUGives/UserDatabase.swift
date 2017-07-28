//
//  UserDatabase.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/18/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import Firebase

class UserDatabase {
    static let sharedInstance = UserDatabase()
    
    //MARK: Properties
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    
    private init() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            print(Auth.auth().currentUser!.uid)
        }
        
        ref = Database.database().reference()
    }
    
    // Get user information from database.
    func login() {
        let handle = self.ref.child("users").child("user-info").child(Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String:AnyObject]
            if let first = value?["Firstname"] as? String {
                self.currentUser.userFirstName = first
            }
            if let last = value?["Lastname"] as? String {
                self.currentUser.userLastName = last
            }
            if let loc = value?["Location"] as? String {
                self.currentUser.userLocation = loc
            }
            if let phone = value?["Phone"] as? String {
                self.currentUser.userPhoneNumber = phone
            }
            if let dob = value?["DOB"] as? String {
                self.currentUser.userDOB = dob
            }
            if let occupation = value?["Occupation"] as? String {
                self.currentUser.userOccupation = occupation
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        ref.removeObserver(withHandle: handle)
    }
    
    // Set user profile in database.
    func signUp() {
        let userRef = self.ref.child("users")
        let newUserRef = userRef.child(Auth.auth().currentUser!.uid).child("user-info")
        let rsvpRef = userRef.child(Auth.auth().currentUser!.uid).child("rsvp-list")
        let createdRef = userRef.child(Auth.auth().currentUser!.uid).child("created-list")
        rsvpRef.setValue("")
        createdRef.setValue("")
        print("The Uid: \(Auth.auth().currentUser!.uid)")
        newUserRef.setValue(self.currentUser.dictionaryObject())
    }
    
    func updateDatabase() {
        let userRef = self.ref.child("users")
        let newUserRef = userRef.child(Auth.auth().currentUser!.uid).child("user-info")
        newUserRef.setValue(self.currentUser.dictionaryObject())
    }
    
    // Get rsvp list from the database.
    func getRsvpList() {
        let handle = self.ref.child("users").child(Auth.auth().currentUser!.uid).child("rsvp-list").observe(.value, with: { (snapshot) in
            guard let rsvpList = snapshot.value as? [String:AnyObject] else {return}
            for (eachKey) in (rsvpList.values) {
                let eventKey = eachKey as? [String:AnyObject]
                guard let key = eventKey?["Key"] as? String else {return}
                self.getEventFromDB(key: key)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        ref.removeObserver(withHandle: handle)
    }
    
    // Get event from the database.
    func getEventFromDB(key: String) {
        let handle = self.ref.child("eventCalendar").child(key).observe(.value, with: { (snapshot) in
            guard let event = snapshot.value as? [String:AnyObject] else {return}
            guard let name = event["eventName"] as? String else {return}
            guard let category = event["eventCategory"] as? String else {return}
            guard let flyerURL = event["eventFlyerURL"] as? String else {return}
            guard let description = event["eventDescription"] as? String else {return}
            guard let capacityString = event["eventCapacity"] as? String else {return}
            let capacity = Int(capacityString)
            guard let contactName = event["eventContactName"] as? String else {return}
            guard let contactEmail = event["eventContactEmail"] as? String else {return}
            guard let street = event["eventStreet"] as? String else {return}
            guard let city = event["eventCity"] as? String else {return}
            guard let state = event["eventState"] as? String else {return}
            guard let zip = event["eventZip"] as? String else {return}
            guard let start = event["eventStart"] as? String else {return}
            guard let end = event["eventEnd"] as? String else {return}
            let newAddress = Address(street: street, city: city, state: state, zip: zip)
            let newEvent = Event.init(eventName: name, eventCategory: category, eventFlyerURL: flyerURL, eventDescription: description, eventStart: start, eventEnd: end, eventAddress: newAddress, eventContactName: contactName, eventContactEmail: contactEmail, eventCapacity: capacity!)
            print(newEvent.eventName)
            if User.sharedInstance.userRsvpEvents.keys.contains(newEvent.eventDate) {
                User.sharedInstance.userRsvpEvents[newEvent.eventDate]?.append(newEvent)
                User.sharedInstance.userRsvpEvents[newEvent.eventDate]?.sort()
            }
            else {
                User.sharedInstance.userRsvpEvents[newEvent.eventDate] = [newEvent]
            }
            print("The # of events in the array: \(User.sharedInstance.userRsvpEvents.count)")
            
        }) { (error) in print(error.localizedDescription) }
        ref.removeObserver(withHandle: handle)
    }
    
    func addRsvpDB(event: Event) {
        self.ref.child("users").child(Auth.auth().currentUser!.uid).child("rsvp-list").child(event.returnKey()).setValue(event.keyDictionaryObject())
    }
    
    func removeRsvpDB(event: Event) {
        self.ref.child("users").child(Auth.auth().currentUser!.uid).child("rsvp-list").child(event.returnKey()).removeValue() { (error) in print("Error: \(error)") }
    }

}
