//
//  EditEventDetailsViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 7/9/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class EditEventDetailsViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: properties
    var detailedEvent:Event?
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventFlyerURLTextField: UITextField!
    @IBOutlet weak var eventCapacityTextField: UITextField!
   
    @IBOutlet weak var eventContactNameTextField: UITextField!
    @IBOutlet weak var eventContactEmailTextField: UITextField!
    @IBOutlet weak var eventStreetAddressTextField: UITextField!
    @IBOutlet weak var eventCityTextField: UITextField!
    @IBOutlet weak var eventStateTextField: UITextField!
    @IBOutlet weak var eventZipTextField: UITextField!
    @IBOutlet weak var eventStartTextField: UITextField!
    @IBOutlet weak var eventEndTextField: UITextField!
    @IBOutlet weak var eventCategoryTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    
    var eventCategories = ["Animals", "Art", "Children at Risk", "Environment", "Health", "Homeless", "Hunger", "Research Labs", "Other" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle text fields' user input through delegate callbacks
        eventNameTextField.delegate = self
        eventFlyerURLTextField.delegate = self
        eventCapacityTextField.delegate = self
        eventContactNameTextField.delegate = self
        eventContactEmailTextField.delegate = self
        eventStreetAddressTextField.delegate = self
        eventCityTextField.delegate = self
        eventStateTextField.delegate = self
        eventZipTextField.delegate = self
        eventStartTextField.delegate = self
        eventEndTextField.delegate = self
        eventCategoryTextField.delegate = self
        eventDescriptionTextView.delegate = self
        
        eventNameTextField.text = detailedEvent?.eventName
        eventFlyerURLTextField.text = detailedEvent?.eventFlyerURL
        eventCapacityTextField.text = detailedEvent?.eventCapacity.description
        eventContactNameTextField.text = detailedEvent?.eventContactName
        eventContactEmailTextField.text = detailedEvent?.eventContactEmail
        eventStreetAddressTextField.text = detailedEvent?.eventAddress.street
        eventCityTextField.text = detailedEvent?.eventAddress.city
        eventStateTextField.text = detailedEvent?.eventAddress.state
        eventZipTextField.text = detailedEvent?.eventAddress.zip
        eventStartTextField.text = detailedEvent?.returnStartDateTime()
        eventEndTextField.text = detailedEvent?.returnEndDateTime()
        eventCategoryTextField.text = detailedEvent?.eventCategory
        eventDescriptionTextView.text = detailedEvent?.eventDescription
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
