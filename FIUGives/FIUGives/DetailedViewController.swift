//
//  DetaledViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 7/2/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class DetailedViewController: UITableViewController {
    var detailedEvent:Event?
    let formatter = DateFormatter()
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventContactName: UILabel!
    @IBOutlet weak var eventContactEmail: UILabel!
    @IBOutlet weak var eventFlyer: UILabel!
    @IBOutlet weak var eventStartDate: UILabel!
    @IBOutlet weak var eventEndDate: UILabel!
    @IBOutlet weak var eventDescription: UITextView!
    @IBOutlet weak var eventAttendees: UITextView!
    
    @IBAction func rsvpButtonClick(_ sender: UIButton) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "YYYY MM dd h:mm a"
        eventName.text = detailedEvent?.eventName
        eventContactName.text = detailedEvent?.eventContactName
        eventContactEmail.text = detailedEvent?.eventContactEmail
        eventFlyer.text = detailedEvent?.eventFlyerURL
        eventStartDate.text = formatter.string(from: (detailedEvent?.eventStart)!)
        eventEndDate.text = formatter.string(from: (detailedEvent?.eventEnd)!)
        eventDescription.text = detailedEvent?.eventDescription
        // Do any additional setup after loading the view.
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
