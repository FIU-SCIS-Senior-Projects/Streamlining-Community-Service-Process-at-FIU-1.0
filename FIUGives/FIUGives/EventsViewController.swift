//
//  EventsViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase


class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    //let dataBaseReference = Database.database().reference(withPath: "eventCalendar")
    var dataBaseReference = Database.database().reference()
    var eventCapacity: Int?
    var eventAddress: Address?
    var newEvent: Event?
    
    
    
    //MARK: IBOutlets
    @IBOutlet weak var eventsTable: UITableView!
    //get the keys from the EventCalendar dictionary & sort them
    var eventDates = Array(EventCalendar.shared.myCalendar.keys)
    
   override func viewDidLoad() {
   super.viewDidLoad()
   var handle = dataBaseReference.child("eventCalendar").observe(.value, with: {
        (snapshot) in
        
        guard let allEvents = snapshot.value as? [String:AnyObject] else {return}
        
        for (eachEvent) in (allEvents.values) {
            
            let eventDetails = eachEvent as? [String:AnyObject]
            guard let name = eventDetails!["eventName"] as? String else {return}
            guard let category = eventDetails!["eventCategory"] as? String else {return}
            guard let flyerURL = eventDetails!["eventFlyerURL"] as? String else {return}
            guard let description = eventDetails!["eventDescription"] as? String else {return}
            guard let capacityString = eventDetails!["eventCapacity"] as? String else {return}
            let capacity = Int(capacityString)
            guard let contactName = eventDetails!["eventContactName"] as? String else {return}
            guard let contactEmail = eventDetails!["eventContactEmail"] as? String else {return}
            guard let street = eventDetails!["eventStreet"] as? String else {return}
            guard let city = eventDetails!["eventCity"] as? String else {return}
            guard let state = eventDetails!["eventState"] as? String else {return}
            guard let zip = eventDetails!["eventZip"] as? String else {return}
            guard let start = eventDetails!["eventStart"] as? String else {return}
            guard let end = eventDetails!["eventEnd"] as? String else {return}
            let newAddress = Address(street: street, city: city, state: state, zip: zip)
            let newEvent = Event.init(eventName: name, eventCategory: category, eventFlyerURL: flyerURL, eventDescription: description, eventStart: start, eventEnd: end, eventAddress: newAddress, eventContactName: contactName, eventContactEmail: contactEmail, eventCapacity: capacity!)
            
            if let eventAttandants = eventDetails!["eventAttendants"] as? [String:String] {
                for (eachAttendant) in eventAttandants {
                    newEvent.eventAttendants.append(eachAttendant.value)
                }
            }
            
            
           //check if the event from the database was already entered to the EventsCalendar model
            if EventCalendar.shared.myCalendar.keys.contains(newEvent.eventDate) {
                if (EventCalendar.shared.myCalendar[newEvent.eventDate]?.contains(newEvent))! {
                print("Duplicate")
                }
                else {
                    EventCalendar.shared.addEvent(newEvent: newEvent)
                    self.eventDates = Array(EventCalendar.shared.myCalendar.keys)
                    self.eventDates.sort()
                    self.eventsTable.reloadData()
                }
            }
            else {
                EventCalendar.shared.addEvent(newEvent: newEvent)
                self.eventDates = Array(EventCalendar.shared.myCalendar.keys)
                self.eventDates.sort()
                self.eventsTable.reloadData()
            }
        }
    })
    dataBaseReference.removeObserver(withHandle: handle)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (EventCalendar.shared.myCalendar[eventDates[section]]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventDates[section].dateComponent()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let formatter = DateFormatter()
        let event = EventCalendar.shared.myCalendar[eventDates[indexPath.section]]?[indexPath.row]
        formatter.dateFormat = "h:mm a"
        cell.textLabel?.text = formatter.string(from: (event?.eventStart)!)
        cell.detailTextLabel?.text = event?.eventName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = EventCalendar.shared.myCalendar[eventDates[indexPath.section]]?[indexPath.row]
        performSegue(withIdentifier: "detailedViewSegue", sender: event)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailedViewSegue" {
        let destination = segue.destination as! DetailedViewController
        destination.detailedEvent = sender as? Event
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
        
    }

    
    

}
