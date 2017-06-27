//
//  AddEventViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import CoreLocation

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
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
    
    var eventCategories = ["Animal Rights", "Arts", "Children", "Homeless", "Hospitals", "Tutoring", "Other" ]
    var startDate = Date() as NSDate
    var endDate = Date() as NSDate
    var eventCategory = ""
    var eventCapacity: Int?
    var eventAddress: Address?
    var newEvent: Event?
    
    @IBAction func rsvpEnabled(_ sender: Any) {
        updateRSVPState()
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        startDate = eventStartDate.date as NSDate
    }
    
    @IBAction func endDateChanged(_ sender: Any) {
        endDate = eventEndDate.date as NSDate
    }

    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        guard ((!(eventNameTextField.text?.isEmpty)!) && (!(eventFlyerURLTextField.text?.isEmpty)!) && (!(eventContactNameTextField.text?.isEmpty)!) && (!(eventContactEmailTextField.text?.isEmpty)!) && (!(eventDescriptionTextView.text?.isEmpty)!) && (!(eventCapacityTextField.text?.isEmpty)!))else {
            //present alert
            let alertController = UIAlertController(title: "Event Not Created", message: "All fields must be completed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            return
        }
        
        if rsvpSwitch.isOn {
            eventCapacity = Int(eventCapacityTextField.text!)
            eventAddress = Address(street: eventStreet.text!, city: eventCity.text!, state: eventState.text!, zip: eventZip.text!)
            newEvent = Event.init(eventName: eventNameTextField.text!, eventCategory: eventCategory, eventFlyerURL: eventFlyerURLTextField.text!, eventDescription: eventDescriptionTextView.text!, eventStart: startDate, eventEnd: endDate, eventAddress:eventAddress!, eventContactName: eventContactNameTextField.text!, eventContactEmail: eventContactEmailTextField.text!, eventRSVPEnabled: true, eventCapacity: eventCapacity!)
            EventCalendar.shared.addEvent(newEvent: newEvent!)
            print("new event created")
            EventCalendar.shared.printDates()
            
        }
        else {
            eventAddress = Address(street: eventStreet.text!, city: eventCity.text!, state: eventState.text!, zip: eventZip.text!)
            newEvent = Event.init(eventName: eventNameTextField.text!, eventCategory: eventCategory, eventFlyerURL: eventFlyerURLTextField.text!, eventDescription: eventDescriptionTextView.text, eventStart: startDate, eventEnd: endDate, eventAddress:eventAddress!, eventContactName: eventContactNameTextField.text!, eventContactEmail: eventContactEmailTextField.text!, eventRSVPEnabled: false)
            EventCalendar.shared.addEvent(newEvent: newEvent!)
            print("new event created")
        }
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
   
    //function to update the rsvp state
    func updateRSVPState() {
        if rsvpSwitch.isOn {
            rsvpEnabled.text = "RSVP enabled"
            eventCapacityTextField.text = ""
        }
        else {
            rsvpEnabled.text = "RSVP disabled"
            eventCapacityTextField.text = "Event capacity unlimited"
        }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
