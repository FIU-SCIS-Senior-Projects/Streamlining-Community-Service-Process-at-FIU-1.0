//
//  DetaledViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import EventKit
import Firebase
import FacebookShare

class DetailedViewController: UITableViewController {
    var detailedEvent:Event?
    let formatter = DateFormatter()
    var rsvpState = true // True = RSVP'd so display Cancel RSVP button. False = not RSVP'd so display RSVP button.
    var eventFull = false
    var newRsvpList = [Event]()
    @IBOutlet var eventDetailsView: UITableView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventContactName: UILabel!
    @IBOutlet weak var eventContactEmail: UIButton!
    @IBOutlet weak var eventFlyer: UIButton!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventAttendees: UITextView!
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var eventAddress: UITextView!
    @IBOutlet weak var facebookButton: UIButton!
    
    
    @IBAction func facebookButtonPressed(_ sender: UIButton) {
        let eventFlyer = URL(string: (detailedEvent?.eventFlyerURL)!)
        let content = LinkShareContent(url: eventFlyer!, title: detailedEvent?.eventName, description: detailedEvent?.eventDescription, imageURL: eventFlyer!)
        do {
            try ShareDialog.show(from: self, content: content)
        } catch {
            print("Error")
        }
    }
    
    @IBAction func eventFlyerPressed(_ sender: UIButton) {
        if let url = URL(string: eventFlyer.currentTitle!), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    @IBAction func contactEmailPressed(_ sender: UIButton) {
        if let url = URL(string: "mailto:\(eventContactEmail.currentTitle)") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func rsvpButtonPressed(sender: UIButton) {
        if !(eventFull) { // Check if the event is full.
        if rsvpState {
            sender.setTitle("RSVP", for: .normal)
            rsvpState = false
            removeRsvp(event: detailedEvent!)
            self.presentAlert(message: "Rsvp cancelled")
        } else {
            // Check if there are no event date conflicts before addingt to rsvp list.
            if (rsvpToEvent(event: detailedEvent!)) {
                sender.setTitle("CANCEL", for: .normal)
                self.presentAlert(message: "Rsvp confirmed")
                detailedEvent?.addToEventAttendants(Attendant: User.sharedInstance.getUserFullName())
                for element in (detailedEvent?.eventAttendants)! {
                    eventAttendees.text = "\(element)\n"
                }
                rsvpState = true
                
                // Add event to phone test.
                addEventToPhoneCalendar(title: (detailedEvent?.eventName)!, description: detailedEvent?.eventDescription, startDate: (detailedEvent?.eventStart)!, endDate: (detailedEvent?.eventEnd)!)
            } else {
                return
            }
            
        } }
        else {
            self.presentAlert(message: "Rsvp for event is not available.")
        }
    }
        
    // Helper function to check if there is a time conflict.
    func getTimeDifference(firstEvent: Date, secondEvent: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: firstEvent, to: secondEvent)
        print("THE TIME DIFFERENCE: \(components.hour)")
        return components.hour!
    }
    
    // Add to Rsvp list if there is no time conflict.
    func rsvpToEvent(event: Event) -> Bool {
        var noConflict = true
        // capacity?
        if User.sharedInstance.userRsvpEvents.isEmpty {
            User.sharedInstance.addRsvpEvent(newEvent: event)
            UserDatabase.sharedInstance.addRsvpDB(event: event)
            noConflict = true
        } else {
            if User.sharedInstance.userRsvpEvents.keys.contains(event.eventDate) {
                for item in (User.sharedInstance.userRsvpEvents[event.eventDate])! {
                    if (getTimeDifference(firstEvent: item.eventEnd, secondEvent: event.eventStart)) > 1   {
                        User.sharedInstance.addRsvpEvent(newEvent: event)
                        UserDatabase.sharedInstance.addRsvpDB(event: event)
                        noConflict = true
                    } else {
                        self.presentAlert(message: "Cannot RSVP. There is a time conflict.")
                        noConflict = false
                    }
                }
            } else {
                User.sharedInstance.addRsvpEvent(newEvent: event)
                UserDatabase.sharedInstance.addRsvpDB(event: event)
                noConflict = true
            }
        }
        return noConflict
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // Remove from rsvp dictionary.
    func removeRsvp(event: Event) {
        if User.sharedInstance.userRsvpEvents.keys.contains(event.eventDate) {
            if (User.sharedInstance.userRsvpEvents[event.eventDate]?.contains(event))! {
                UserDatabase.sharedInstance.removeRsvpDB(event: event)
                let index = User.sharedInstance.userRsvpEvents[event.eventDate]?.index(of: event)
                User.sharedInstance.userRsvpEvents[event.eventDate]?.remove(at: index!)
            } else {
                print("no event found in rsvp list")
                return
            }
        }
        // Remove from event attendees array.
        event.removeEventAttendant(Attendant: User.sharedInstance.getUserFullName())
        tableView.reloadData()
    }

    // Add event to phone calendar.
    func addEventToPhoneCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
    // Check if user has rsvp'd to event.
    func setUpRsvpButton(event: Event) {
        if checkIfEventFull(event: detailedEvent!) {
            eventFull = true
            rsvpButton.setTitle("FULL", for: .normal)
        } else {
            if User.sharedInstance.userRsvpEvents.keys.contains(event.eventDate) {
                if (User.sharedInstance.userRsvpEvents[event.eventDate]?.contains(event))! {
                    rsvpButton.setTitle("Cancel", for: .normal)
                    rsvpState = true
                } else {
                    rsvpButton.setTitle("RSVP", for: .normal)
                    rsvpState = false
                }
            } else {
                rsvpButton.setTitle("RSVP", for: .normal)
                rsvpState = false
            }
        }
    }

    // Check if the event is full before anything.
    func checkIfEventFull(event: Event) -> Bool {
        if (event.eventCapacity != 0) && (event.eventAttendants.count == event.eventCapacity) {
            return true
        } else {
            return false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDatabase.sharedInstance.getRsvpList()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        setUpRsvpButton(event: detailedEvent!)
        formatter.dateFormat = "EEEE, MMM dd YYYY, h:mm a"
        eventName.text = detailedEvent?.eventName
        eventContactName.text = detailedEvent?.eventContactName
        eventFlyer.setTitle(detailedEvent?.eventFlyerURL, for: .normal)
        eventContactEmail.setTitle(detailedEvent?.eventContactEmail, for: .normal)
        eventStartDate.text = formatter.string(from: (detailedEvent?.eventStart)!)
        eventEndDate.text = formatter.string(from: (detailedEvent?.eventEnd)!)
        eventDescription.text = detailedEvent?.eventDescription
        eventAddress.text = detailedEvent?.eventAddress.fullAddress()
        for element in (detailedEvent?.eventAttendants)! {
            eventAttendees.text = "\(element)\n"
        }
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
