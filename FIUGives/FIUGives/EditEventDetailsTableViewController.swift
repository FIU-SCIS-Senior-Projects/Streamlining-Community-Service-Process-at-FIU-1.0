//
//  EditEventDetailsTableViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 7/12/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class EditEventDetailsTableViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var detailedEvent: Event?

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
    
    
    
    
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()

    
    let changeDatePicker = UIDatePicker()
    var startDate: Date?
    var endDate: Date?
    var tempDescription: String?
    var eventCapacity: Int?
    var eventAddress: Address?
    let categoryPicker = UIPickerView()
    var eventCategories = ["Animals", "Art", "Children at Risk", "Environment", "Health", "Homeless", "Hunger", "Research Labs", "Other" ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        //print(self.getUser())
        
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
        
        tempDescription = detailedEvent?.eventDescription
        startDate = detailedEvent?.eventStart
        endDate = detailedEvent?.eventEnd
        eventCapacity = detailedEvent?.eventCapacity
        
        categoryPicker.dataSource = self
        categoryPicker.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.barTintColor = UIColor.lightText
        toolBar.tintColor = UIColor.darkText
        toolBar.sizeToFit()
        let changeButton = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.changeDescription))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.returnDescription))
        toolBar.isUserInteractionEnabled = true
        toolBar.setItems([cancelButton, spaceButton, changeButton], animated: false)
        eventDescriptionTextView.inputAccessoryView = toolBar
    }
   
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        //present Datepicker for eventStartTextField & eventEndTextField
        changeDatePicker.datePickerMode = UIDatePickerMode.dateAndTime
        changeDatePicker.backgroundColor = UIColor.white
        //event time changes only allowed within the range of the originsl event date
        var comp = DateComponents()
        comp.day = 1
        comp.minute = -1
        changeDatePicker.minimumDate = detailedEvent?.eventDate.myEventDate
        changeDatePicker.maximumDate = Calendar.current.date(byAdding: comp, to: (detailedEvent?.eventDate.myEventDate)!)
        eventStartTextField.inputView = changeDatePicker
        eventEndTextField.inputView = changeDatePicker
        
        categoryPicker.backgroundColor = UIColor.white
        eventCategoryTextField.inputView = categoryPicker

        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.darkText
        //toolBar.addSubview(line)
        let setStartButton = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.changeStartTime))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.cancelChangeTime))
        let setEndButton = UIBarButtonItem(title: "Set", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.changeEndTime))
        let cancelCategoryButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.cancelChangeCategory))
        let changeCategorButton = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.changeCategory))
        let changeButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.change))
        toolBar.isUserInteractionEnabled = true
        
        switch textField {
        case eventStartTextField:
            toolBar.setItems([cancelButton, spaceButton, setStartButton], animated: false)
            textField.inputAccessoryView = toolBar
        case eventEndTextField:
            toolBar.setItems([cancelButton, spaceButton, setEndButton], animated: false)
            textField.inputAccessoryView = toolBar
        case eventCategoryTextField:
            toolBar.setItems([cancelCategoryButton, spaceButton, changeCategorButton], animated: false)
            textField.inputAccessoryView = toolBar
        case eventCapacityTextField,
             eventZipTextField:
            toolBar.setItems([spaceButton, spaceButton, changeButton], animated: false)
            textField.inputAccessoryView = toolBar
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (textField.text?.isEmpty)! {
            self.presentAlert(message: "Provide a valid value!")
            return false
        }
        else {
            textField.resignFirstResponder()
            return true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == eventNameTextField {
            self.presentAlert(message: "Name Change Not Allowed!")
            return false
        }
        else {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.saveChanges))
        return true
        }
    }

    func textViewDidChange(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.saveChanges))
    }
    
    func returnDescription() {
        eventDescriptionTextView.text = tempDescription
        eventDescriptionTextView.resignFirstResponder()
    }
    func changeDescription() {
        if (eventDescriptionTextView.text.isEmpty) {
            self.presentAlert(message: "Provide a valid value!")
        }
        else {
            tempDescription = eventDescriptionTextView.text
            eventDescriptionTextView.resignFirstResponder()
        }
    }

    func changeStartTime() {
        eventStartTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        eventStartTextField.text = formatter.string(from: changeDatePicker.date)
        startDate = changeDatePicker.date
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.saveChanges))
    }
    func changeEndTime() {
        eventEndTextField.resignFirstResponder()
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy h:mm a"
        eventEndTextField.text = formatter.string(from: changeDatePicker.date)
        endDate = changeDatePicker.date
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.saveChanges))
    }
    func cancelChangeTime() {
        eventStartTextField.resignFirstResponder()
        eventEndTextField.resignFirstResponder()
    }
    
    //PickerView methods
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventCategories.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return eventCategories[row]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func changeCategory() {
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(EditEventDetailsTableViewController.saveChanges))
        eventCategoryTextField.text = eventCategories[categoryPicker.selectedRow(inComponent: 0)]
        eventCategoryTextField.resignFirstResponder()
    }
    func cancelChangeCategory() {
        eventCategoryTextField.resignFirstResponder()
    }
    
    func change() {
        if ((eventCapacityTextField.text?.isEmpty)! || (eventZipTextField.text?.isEmpty)!) {
            self.presentAlert(message: "Provide a valid value!")
        }
        else {
        eventCapacity = Int(eventCapacityTextField.text!)
        eventCapacityTextField.resignFirstResponder()
        eventZipTextField.resignFirstResponder()
        }
    }
    
    //function to present alert message
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
        
    }
    
    func saveChanges() {
        if detailedEvent?.eventName != eventNameTextField.text {
            detailedEvent?.updateName(eventName: eventNameTextField.text!)
        }
        if detailedEvent?.eventFlyerURL != eventFlyerURLTextField.text {
            detailedEvent?.updateFlyerURL(eventFlyerURL: eventFlyerURLTextField.text!)
        }
        if detailedEvent?.eventCapacity != eventCapacity {
            detailedEvent?.updateCapacity(eventCapacity: eventCapacity!)
        }
        if detailedEvent?.eventContactName != eventContactNameTextField.text {
            detailedEvent?.updateContactName(eventContactName: eventContactNameTextField.text!)
        }
        if detailedEvent?.eventContactEmail != eventContactEmailTextField.text {
            detailedEvent?.updateContactEmail(eventContactEmail: eventContactEmailTextField.text!)
        }
        if detailedEvent?.eventAddress.street != eventStreetAddressTextField.text || detailedEvent?.eventAddress.city != eventCityTextField.text || detailedEvent?.eventAddress.state != eventStateTextField.text || detailedEvent?.eventAddress.zip != eventZipTextField.text {
            eventAddress = Address(street: eventStreetAddressTextField.text!, city: eventCityTextField.text!, state: eventStateTextField.text!, zip: eventZipTextField.text!)
            detailedEvent?.updateAddress(eventAddress: eventAddress!)
        }
        if detailedEvent?.eventStart != startDate {
            if (endDate! < startDate!) {
                self.presentAlert(message: "End On Date can not preceed Start On Date")
            }
            detailedEvent?.updateStartDate(eventStartDate: startDate!)
        }
        if detailedEvent?.eventEnd != endDate {
            if (endDate! < startDate!) {
                self.presentAlert(message: "End On Date can not preceed Start On Date")
            }
            detailedEvent?.updateEndDate(eventEndDate: endDate!)
        }
        if detailedEvent?.eventCategory != eventCategoryTextField.text {
            detailedEvent?.updateCategory(eventCategory: eventCategoryTextField.text!)
        }
        if detailedEvent?.eventDescription != eventDescriptionTextView.text {
            detailedEvent?.updateDescription(eventDescription: eventDescriptionTextView.text)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    // Get user information
    func getUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userUID = Auth.auth().currentUser!.uid
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  

}
