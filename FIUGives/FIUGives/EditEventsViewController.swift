//
//  FilterEventsViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class EditEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var userEventsCreatedTable: UITableView!
    
    var dataBaseReference = Database.database().reference()
    var eventsList = [String]()
    //var eventsCreated = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let userID = Auth.auth().currentUser?.uid
       //get the event IDs for the events created by the user from the database
        dataBaseReference.child("users").child(userID!).observe(.value, with: { (snapshot) in
            guard let userDetails = snapshot.value as? NSDictionary else {return}
            guard let eventsCreated = userDetails["created-list"] as? [String:String] else {return}
            for (eachEventCreated) in eventsCreated.values {
                self.eventsList.append(eachEventCreated)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
       
        
        dataBaseReference.child("eventCalendar").observe(.value, with: {
            (snapshot) in
            
            guard let allEvents = snapshot.value as? NSDictionary else {return}
            
            for eachEventCreated in self.eventsList {
                guard let eventDetails = allEvents[eachEventCreated] as? [String:AnyObject] else {return}
                guard let name = eventDetails["eventName"] as? String else {return}
                guard let category = eventDetails["eventCategory"] as? String else {return}
                guard let flyerURL = eventDetails["eventFlyerURL"] as? String else {return}
                guard let description = eventDetails["eventDescription"] as? String else {return}
                guard let capacityString = eventDetails["eventCapacity"] as? String else {return}
                let capacity = Int(capacityString)
                guard let contactName = eventDetails["eventContactName"] as? String else {return}
                guard let contactEmail = eventDetails["eventContactEmail"] as? String else {return}
                guard let street = eventDetails["eventStreet"] as? String else {return}
                guard let city = eventDetails["eventCity"] as? String else {return}
                guard let state = eventDetails["eventState"] as? String else {return}
                guard let zip = eventDetails["eventZip"] as? String else {return}
                guard let start = eventDetails["eventStart"] as? String else {return}
                guard let end = eventDetails["eventEnd"] as? String else {return}
                let newAddress = Address(street: street, city: city, state: state, zip: zip)
                let newEvent = Event.init(eventName: name, eventCategory: category, eventFlyerURL: flyerURL, eventDescription: description, eventStart: start, eventEnd: end, eventAddress: newAddress, eventContactName: contactName, eventContactEmail: contactEmail, eventCapacity: capacity!)
                User.sharedInstance.addToUserEventCreated(Event: newEvent)
                self.userEventsCreatedTable.reloadData()
                //self.eventsCreated.append(newEvent)
                //self.eventsCreated.sort()
                //print(self.eventsCreated[0].eventName)
            }
        })
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.userEventsCreatedTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.userEventCreated.count
        //return eventsCreated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editEventCell", for: indexPath)
        let formatter = DateFormatter()
        let event = User.sharedInstance.userEventCreated[indexPath.row]
        //let event = eventsCreated[indexPath.row]
        formatter.dateFormat = "MMM d, h:mm a"
        cell.textLabel?.text = event.eventName
        cell.detailTextLabel?.text = formatter.string(from: event.eventStart)
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = User.sharedInstance.userEventCreated[indexPath.row]
        //let event = eventsCreated[indexPath.row]
        performSegue(withIdentifier: "editEventSegue", sender: event)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editEventSegue" {
            let destination = segue.destination as! EditEventDetailsTableViewController
            destination.detailedEvent = (sender as? Event)!
        }
    }
    


  

}
