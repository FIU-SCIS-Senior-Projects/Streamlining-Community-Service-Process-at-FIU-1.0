//
//  DetaledViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 7/2/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var detailedEvent:Event?
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDateLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var eventAddressTextView: UITextView!
    @IBOutlet weak var eventDescriptionTextView: UITextView!

    @IBOutlet weak var eventContactNameLabel: UILabel!
    @IBOutlet weak var eventContactEmailLabel: UILabel!
    @IBOutlet weak var eventContactTelephoneTextView: UITextView!
    
    @IBOutlet weak var eventURLTextView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        eventNameLabel.text = detailedEvent?.eventName
        eventDateLabel.text = detailedEvent?.returnStartDate()
        eventTimeLabel.text = "from "+(detailedEvent?.returnStartTime())!+" to "+(detailedEvent?.returnEndTime())!
        eventAddressTextView.text = detailedEvent?.eventAddress.fullAddress()
        eventDescriptionTextView.text = detailedEvent?.eventDescription
        eventContactNameLabel.text = detailedEvent?.eventContactName
        eventContactEmailLabel.text = detailedEvent?.eventContactEmail
        eventURLTextView.text = detailedEvent?.eventFlyerURL
        
        
        
        
        
   
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
