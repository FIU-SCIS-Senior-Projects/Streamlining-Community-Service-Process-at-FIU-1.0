//
//  AddEventViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//
//verify network connection prior to adding the event


import UIKit
import CoreLocation
import Firebase



class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let dataBaseReference = Database.database().reference()

    

    //MARK: properties
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventFlyerURLTextField: UITextField!
    @IBOutlet weak var eventContactNameTextField: UITextField!
    @IBOutlet weak var eventContactEmailTextField: UITextField!
    @IBOutlet weak var eventStreet: UITextField!
    @IBOutlet weak var eventCity: UITextField!
    @IBOutlet weak var eventState: UITextField!
    @IBOutlet weak var eventZip: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventStartDate: UIDatePicker!
    @IBOutlet weak var eventEndDate: UIDatePicker!
    @IBOutlet weak var rsvpEnabled: UILabel!
    @IBOutlet weak var rsvpSwitch: UISwitch!
    @IBOutlet weak var eventCapacityTextField: UITextField!
    @IBOutlet weak var eventCategoryPickerView: UIPickerView!
    
    var eventCategories = ["Animals", "Art", "Children at Risk", "Environment", "Health", "Homeless", "Hunger", "Research Labs", "Other"]
    //var startDate = Date()
    //var endDate = Date()
    var eventCategory = "Animals"
    var eventCapacity: Int?
    var eventAddress: Address?
    var newEvent: Event?

    
    @IBAction func rsvpEnabled(_ sender: Any) {
        updateRSVPState()
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        let cal = Calendar.current
        var comp = DateComponents()
        comp.day = 1
        comp.minute = -1
        //startDate = eventStartDate.date
        eventEndDate.minimumDate = eventStartDate.date
        eventEndDate.maximumDate = cal.date(byAdding: comp, to: cal.startOfDay(for: eventStartDate.date))
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        let cal = Calendar.current
        var comp = DateComponents()
        comp.day = 1
        comp.minute = -1
        //startDate = eventStartDate.date
        eventEndDate.minimumDate = eventStartDate.date
        eventEndDate.maximumDate = cal.date(byAdding: comp, to: cal.startOfDay(for: eventStartDate.date))
    }

    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        
        //Perform checks if all the fields are filled out
        guard !(eventNameTextField.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Event Name cannot be blank")
            return
        }
        guard !(eventFlyerURLTextField.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Event Flyer URL cannot be blank")
            return
        }
        guard !(eventContactNameTextField.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Event Contact Name cannot be blank")
            return
        }
        guard !(eventContactEmailTextField.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Event Contact Email cannot be blank")
            return
        }
        guard !(eventStreet.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Street Address cannot be blank")
            return
        }
        guard !(eventCity.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "City cannot be blank")
            return
        }
        guard !(eventState.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "State cannot be blank")
            return
        }
        guard !(eventZip.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Zip cannot be blank")
            return
        }
        guard !(eventDescriptionTextView.text?.isEmpty)! else {
            //present alert
            presentAlert(alertMessage: "Event Description cannot be blank")
            return
        }
        
        eventAddress = Address(street: eventStreet.text!, city: eventCity.text!, state: eventState.text!, zip: eventZip.text!)
        
        
        if (EventCalendar.shared.myCalendar.keys.contains(EventDate(myEventDate: eventStartDate.date))){
            
            for eachEvent in EventCalendar.shared.myCalendar[(EventDate(myEventDate: eventStartDate.date))]! {
                
                if (eventNameTextField.text == eachEvent.eventName) {
                    self.presentAlert(alertMessage: "Consider changing the name. Event with sunch name on the same date already exists!")
                    return
                }
            }
        }
        
        if rsvpSwitch.isOn {
            guard !(eventCapacityTextField.text?.isEmpty)! else {
                //present alert
                presentAlert(alertMessage: "Event Capacity cannot be blank")
                return
            }
            eventCapacity = Int(eventCapacityTextField.text!)
            newEvent = Event.init(eventName: eventNameTextField.text!, eventCategory: eventCategory, eventFlyerURL: eventFlyerURLTextField.text!, eventDescription: eventDescriptionTextView.text!, eventStart: eventStartDate.date, eventEnd: eventEndDate.date, eventAddress:eventAddress!, eventContactName: eventContactNameTextField.text!, eventContactEmail: eventContactEmailTextField.text!, eventCapacity: eventCapacity!)
        }
        else {
            newEvent = Event.init(eventName: eventNameTextField.text!, eventCategory: eventCategory, eventFlyerURL: eventFlyerURLTextField.text!, eventDescription: eventDescriptionTextView.text, eventStart: eventStartDate.date, eventEnd: eventEndDate.date, eventAddress:eventAddress!, eventContactName: eventContactNameTextField.text!, eventContactEmail: eventContactEmailTextField.text!)
        }
        
        let userID = Auth.auth().currentUser?.uid
        self.dataBaseReference.child("eventCalendar").child((newEvent?.returnKey())!).setValue(newEvent?.dictionaryObject())
        self.dataBaseReference.child("users").child(userID!).child("created-list").childByAutoId().setValue(newEvent?.returnKey())
        self.navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //handle text fields' user input through delegate callbacks
        eventNameTextField.delegate = self
        eventFlyerURLTextField.delegate = self
        eventContactNameTextField.delegate = self
        eventContactEmailTextField.delegate = self
        eventStreet.delegate = self
        eventCity.delegate = self
        eventState.delegate = self
        eventZip.delegate = self
        eventDescriptionTextView.delegate = self
     
        eventCategoryPickerView.delegate = self
        eventCategoryPickerView.dataSource = self
        
        updateRSVPState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }
   

    //UIPickerView methods
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return eventCategories.count
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return eventCategories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            eventCategory = eventCategories[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    //helper methods
    
    //function to present alert message
    func presentAlert(alertMessage: String) {
        let alertController = UIAlertController(title: "Event Not Created", message: alertMessage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
        
    }
    
    //function to update the rsvp state
    func updateRSVPState() {
        if rsvpSwitch.isOn {
            rsvpEnabled.text = "Set Event Capacity"
            eventCapacityTextField.text = ""
        }
        else {
            rsvpEnabled.text = "Unlimited Capacity"
            eventCapacityTextField.text = "UNLIMITED"
        }
    }


}
