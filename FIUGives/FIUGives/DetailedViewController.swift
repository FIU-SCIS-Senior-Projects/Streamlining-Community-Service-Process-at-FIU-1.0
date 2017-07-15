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

class DetailedViewController: UITableViewController {
    var detailedEvent:Event?
    var ref: DatabaseReference!
    let formatter = DateFormatter()
    var rsvpState = true // True = RSVP'd so display Cancel RSVP button. False = not RSVP'd so display RSVP button.
    var userRsvpList = User.sharedInstance.userRsvpEvents
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
        ref = Database.database().reference(withPath: "rsvp-list")
        // If user is rsvp'd.
        if rsvpState {
            sender.setTitle("RSVP", for: .normal)
            rsvpState = false
            removeRsvp(event: detailedEvent!)
            self.presentAlert(message: "Rsvp cancelled")
        } else {
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
            
            /* Add to database
             let rsvpEventRef = self.ref.child((detailedEvent?.eventName.lowercased())!)
             rsvpEventRef.setValue(detailedEvent?.dictionaryObject())*/
        }
    }
    
    func getTimeDifference(firstEvent: Date, secondEvent: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour], from: firstEvent, to: secondEvent)
        print("THE TIME DIFFERENCE: \(components.hour)")
        return components.hour!
    }
    
    func rsvpToEvent(event: Event) -> Bool {
        var noConflict = true
        // capacity?
        if userRsvpList.isEmpty {
            User.sharedInstance.addRsvpEvent(newEvent: detailedEvent!)
            for item in User.sharedInstance.userRsvpEvents {
                for thing in item.value {
                    print("Events in the RSVP array: \(thing.eventName)")
                }
            }
            noConflict = true
        } else {
            for item in userRsvpList {
                if item.key == event.eventDate {
                    for thing in item.value {
                        if (getTimeDifference(firstEvent: thing.eventEnd, secondEvent: event.eventStart)) > 1   {
                            User.sharedInstance.addRsvpEvent(newEvent: detailedEvent!)
                            noConflict = true
                        } else {
                            self.presentAlert(message: "Cannot RSVP. There is a time conflict.")
                            noConflict = false
                        }
                    }
                } else {
                    User.sharedInstance.addRsvpEvent(newEvent: detailedEvent!)
                    noConflict = true
                }
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
        for item in userRsvpList {
            if item.key == event.eventDate {
                newRsvpList = item.value
                print("BEG LIST COUNT: \(newRsvpList.count)")
                for item in newRsvpList {
                    print("EACH EVENT: \(item.eventName)")
                }
                if let index = newRsvpList.index(of: event) {
                    newRsvpList.remove(at: index)
                    for item in newRsvpList {
                        print("EACH EVENT: \(item.eventName)")
                    }
                    print("END LIST COUNT: \(newRsvpList.count)")
                }
                userRsvpList.updateValue(newRsvpList, forKey: item.key)
                for each in userRsvpList {
                    if each.key == event.eventDate {
                        for thing in each.value {
                            print("EACH EVENT: \(thing.eventName)")
                        }
                        print("FIN LIST COUNT: \(each.value.count)")
                    }
                }
            } else { return }
        }
        // Remove from event attendees array.
        event.removeEventAttendant(Attendant: User.sharedInstance.getUserFullName())
        tableView.reloadData()
    }

    // Testing adding event to phone calendar.
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
    func checkIfUserRsvp(event: Event) {
        if userRsvpList.isEmpty {
            rsvpButton.setTitle("RSVP", for: .normal)
            rsvpState = false
        } else {
            for item in userRsvpList {
                if item.key == event.eventDate {
                    // If event is found in rsvp list, then rsvpState = true.
                    if item.value.index(of: event) != nil {
                        rsvpButton.setTitle("Cancel", for: .normal)
                        rsvpState = true
                    } else {
                        rsvpButton.setTitle("RSVP", for: .normal)
                        rsvpState = false
                    }
                } else {
                    if item.value.index(of: event) != nil {
                        rsvpButton.setTitle("Cancel", for: .normal)
                        rsvpState = true
                    } else {
                        rsvpButton.setTitle("RSVP", for: .normal)
                        rsvpState = false
                    }
                }
            }
        }
    }
    
    func checkIfEventFull(event: Event) {
        if event.eventAttendants.count == event.eventCapacity {
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        formatter.dateFormat = "EEEE, MMM dd YYYY, h:mm a"
        checkIfEventFull(event: detailedEvent!)
        checkIfUserRsvp(event: detailedEvent!)
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
