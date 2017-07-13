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
    
    let changeDatePicker = UIDatePicker()
    var startDate: Date?
    var endDate: Date?
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //present Datepicker for eventStartTextField
        changeDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        changeDatePicker.backgroundColor = UIColor.white
        eventStartTextField.inputView = changeDatePicker
        eventEndTextField.inputView = changeDatePicker
        
       //startDatePicker.addTarget(self, action: #selector(EditEventDetailsViewController.startDateChanged), for: UIControlEvents.valueChanged)
    
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.black
        
        let setStartButton = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(EditEventDetailsViewController.changeStartTime))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditEventDetailsViewController.cancelChangeTime))
        let setEndButton = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(EditEventDetailsViewController.changeEndTime))
        toolBar.isUserInteractionEnabled = true
        
        if textField == eventStartTextField {
            toolBar.setItems([cancelButton, spaceButton, setStartButton], animated: false)
            textField.inputAccessoryView = toolBar
            
            var comp = DateComponents()
            comp.day = 1
            comp.minute = -1
            changeDatePicker.minimumDate = detailedEvent?.eventDate.myEventDate
            changeDatePicker.maximumDate = Calendar.current.date(byAdding: comp, to: (detailedEvent?.eventDate.myEventDate)!)
        }
        if textField == eventEndTextField {
            toolBar.setItems([cancelButton, spaceButton, setEndButton], animated: false)
            textField.inputAccessoryView = toolBar
        }
    }

    
    func changeStartTime() {
        eventStartTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        eventStartTextField.text = formatter.string(from: changeDatePicker.date)
        startDate = changeDatePicker.date
    }
    func changeEndTime() {
        eventEndTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        eventEndTextField.text = formatter.string(from: changeDatePicker.date)
        endDate = changeDatePicker.date
    }
    func cancelChangeTime() {
        eventStartTextField.resignFirstResponder()
        eventEndTextField.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

}
