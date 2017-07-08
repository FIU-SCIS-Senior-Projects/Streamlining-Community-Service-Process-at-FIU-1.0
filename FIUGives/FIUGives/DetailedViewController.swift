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
    var rsvpState = true // true is RSVP, false is Cancel RSVP
    // var rsvpList = User.sharedInstance.userRsvpEvents
    @IBOutlet var eventDetailsView: UITableView!
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventContactName: UILabel!
    @IBOutlet weak var eventContactEmail: UILabel!
    @IBOutlet weak var eventFlyer: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventAttendees: UITextView!
    @IBOutlet weak var rsvpButton: UIButton!
    @IBOutlet weak var eventAddress: UITextView!
    
    @IBAction func rsvpButtonPressed(sender: UIButton) {
        ref = Database.database().reference(withPath: "rsvp-list")
        if rsvpState {
            sender.setTitle("Cancel", for: .normal)
            rsvpState = false
            // Add to database
            let rsvpEventRef = self.ref.child((detailedEvent?.eventName.lowercased())!)
                rsvpEventRef.setValue(detailedEvent?.dictionaryObject())
            self.presentAlert(message: "Rsvp confirmed")
            
            // Add event to phone test
            addEventToPhoneCalendar(title: (detailedEvent?.eventName)!, description: detailedEvent?.eventDescription, startDate: (detailedEvent?.eventStart)!, endDate: (detailedEvent?.eventEnd)!)
        }
        else {
            sender.setTitle("RSVP", for: .normal)
            rsvpState = true
            // removeRsvp(event: detailedEvent!)
            // Need to remove from database
            self.presentAlert(message: "Rsvp cancelled")
        }
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // Need to remove from database
    func removeRsvp(event: Event) {
        /* if let index = rsvpList.index(of: event) {
            self.rsvpList.remove(at: index)
        }*/
    }
    
    // Test
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
    
    func checkIfUserRsvp(event: Event) {
        /* for item in rsvpList {
            if item.eventName == event.eventName {
                rsvpButton.setTitle("Cancel", for: .normal)
                rsvpState = false
            } else {
                rsvpButton.setTitle("RSVP", for: .normal)
                rsvpState = true
            }
        }*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "EEEE, MMM dd YYYY, h:mm a"
        checkIfUserRsvp(event: detailedEvent!)
        eventName.text = detailedEvent?.eventName
        eventContactName.text = detailedEvent?.eventContactName
        eventContactEmail.text = detailedEvent?.eventContactEmail
        eventFlyer.text = detailedEvent?.eventFlyerURL
        eventStartDate.text = formatter.string(from: (detailedEvent?.eventStart)!)
        eventEndDate.text = formatter.string(from: (detailedEvent?.eventEnd)!)
        eventDescription.text = detailedEvent?.eventDescription
        eventAddress.text = detailedEvent?.eventAddress.fullAddress()
        // Do any additional setup after loading the view.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
