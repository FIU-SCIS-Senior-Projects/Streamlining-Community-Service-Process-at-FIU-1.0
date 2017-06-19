//
//  AddEventViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class AddEventViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: properties
    
    @IBOutlet weak var eventNameTextField: UITextField!
    @IBOutlet weak var eventFlyerURLTextField: UITextField!
    @IBOutlet weak var eventContactNameTextField: UITextField!
    @IBOutlet weak var eventContactEmailTextField: UITextField!
    @IBOutlet weak var eventDescriptionTextView: UITextView!
    @IBOutlet weak var eventLocationTextField: UITextField!
    @IBOutlet weak var eventStartDate: UIDatePicker!
    @IBOutlet weak var eventEndDate: UIDatePicker!
    @IBOutlet weak var rsvpEnabled: UILabel!
    @IBOutlet weak var rsvpSwitch: UISwitch!
    @IBOutlet weak var eventCapacity: UITextField!
    
    
    
    var eventName: String?
    var eventFlyerURL: String?
    var eventContactName: String?
    var eventContactEmail: String?
    var eventDescription: String?
    var eventLocationName: String?
 
    
    @IBAction func rsvpEnabled(_ sender: Any) {
        updateRSVPState()
    }
    
    
    @IBAction func addEvent(_ sender: UIBarButtonItem) {
        
        guard ((!(eventNameTextField.text?.isEmpty)!) && (!(eventFlyerURLTextField.text?.isEmpty)!) && (!(eventContactNameTextField.text?.isEmpty)!) && (!(eventContactEmailTextField.text?.isEmpty)!) && (!(eventDescriptionTextView.text?.isEmpty)!) && (!(eventLocationTextField.text?.isEmpty)!)) else {
            //present alert
            let alertController = UIAlertController(title: "Event Not Created", message: "All fields must be completed", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .destructive)
            alertController.addAction(okAction)
            self.present(alertController, animated: true)
            
            return
        }
        
        eventName = eventNameTextField.text!
        eventFlyerURL = eventFlyerURLTextField.text!
        eventContactName = eventContactNameTextField.text!
        eventContactEmail = eventContactNameTextField.text!
        eventDescription = eventDescriptionTextView.text!
        eventLocationName = eventLocationTextField.text!
        
        
        
        
    }

    


    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //handle text fields' user input through delegate callbacks
        eventNameTextField.delegate = self
        eventFlyerURLTextField.delegate = self
        eventContactNameTextField.delegate = self
        eventContactEmailTextField.delegate = self
        eventDescriptionTextView.delegate = self
        eventLocationTextField.delegate = self
        
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
        }
        else {
            rsvpEnabled.text = "RSVP disabled"
            eventCapacity.text = "Event capacity unlimited"
        }
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
