//
//  EditProfileTableViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/6/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var locationField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephoneField: UITextField!
    @IBOutlet weak var dateOfBirthField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var managePasswordButton: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    let selectDatePicker = UIDatePicker()
    var currentUser = User.sharedInstance
    
    @IBAction func uploadButton(_ sender: UIButton) {
        // for later
    }
    
    @IBAction func saveUserProfile(_ sender: UIBarButtonItem) {
        if !(firstnameField.text!.isEmpty) {
            guard (firstnameField.text!.characters.count > 2) else {
            presentAlert(message: "Firstname must contain at least 2 characters")
            return
            }
        }
        
        if !(lastnameField.text!.isEmpty) {
            guard (lastnameField.text!.characters.count > 2) else {
                presentAlert(message: "Lastname must contain at least 2 characters")
                return
            }
        }

        /* Validation for email format.
        if !(emailField.text!.isEmpty) {
            guard (emailField.text!.contains("@")) else {
                presentAlert(message: "Please enter a valid email address.")
                return
            }
            
       
            Auth.auth().currentUser?.updateEmail(to: emailField.text!) { (error) in
                if let error = error {
                    self.presentAlert(message: error.localizedDescription)
                    return
                } else {
                    print("Successful Email Change")
                    self.getPassword(message: "Please input your password")
                    let credential = EmailAuthProvider.credential(withEmail: self.emailField.text!, password: self.passwordField.text!)
                    Auth.auth().currentUser?.reauthenticate(with: credential) { error in
                        if error != nil {
                            self.presentAlert(message: (error?.localizedDescription)!)
                        } else {
                            print("Successfully reauthenticated.")
                            self.presentAlert(message: "Email was successfully changed.")
                        }
                    }
                }
            }
        }*/
        
        // Validation for numbers in telephone field.
        if !((telephoneField.text!.isEmpty)) {
            guard (Int((telephoneField.text!)) != nil) else {
                presentAlert(message: "Please enter a valid phone number.")
                return
            }
        }
        
        self.firstnameField.resignFirstResponder()
        self.lastnameField.resignFirstResponder()
        self.dateOfBirthField.resignFirstResponder()
        self.locationField.resignFirstResponder()
        self.telephoneField.resignFirstResponder()
        self.emailField.resignFirstResponder()
        self.occupationField.resignFirstResponder()

        
        self.updateUserObject()
        UserDatabase.sharedInstance.updateDatabase()
        self.navigationController?.popViewController(animated: true)
    }
    
    // Check if user fields are different/not empty before updating the database.
    func updateUserObject() {
        if !(currentUser.userFirstName == firstnameField.text) && !((firstnameField.text!.isEmpty)) {
            currentUser.setUserFirstName(First: firstnameField.text!)
        }
        if !(currentUser.userLastName == lastnameField.text) && !((lastnameField.text!.isEmpty)) {
            currentUser.setUserLastName(Last: lastnameField.text!)
        }
        
        if !(currentUser.userLocation == locationField.text) && !((locationField.text!.isEmpty)) {
            currentUser.setUserLocation(Location: locationField.text!)
        }
        
        if !(currentUser.userDOB == dateOfBirthField.text) && !((dateOfBirthField.text!.isEmpty)) {
            currentUser.setUserDateOfBirth(Birth: dateOfBirthField.text!)
        }
        
        if !(currentUser.userPhoneNumber == telephoneField.text) && !((telephoneField.text!.isEmpty)) {
            currentUser.setUserPhoneNumber(Phone: telephoneField.text!)
        }
        
        if !(currentUser.userOccupation == occupationField.text) && !((occupationField.text!.isEmpty)) {
            currentUser.setUserOccupation(Occupation: occupationField.text!)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //hide the keyboard
        textField.resignFirstResponder()
        return true
    }

    // Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // Date picker for user date of birth.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectDatePicker.datePickerMode = UIDatePickerMode.date
        selectDatePicker.backgroundColor = UIColor.white
        dateOfBirthField?.inputView = selectDatePicker
        selectDatePicker.addTarget(self, action: #selector(UserSignUpController.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = false
        toolBar.sizeToFit()
        toolBar.tintColor = UIColor.black
        
        let saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(UserSignUpController.saveDob))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(UserSignUpController.cancelSearch))
        toolBar.setItems([cancelButton, spaceButton, saveButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        dateOfBirthField.inputAccessoryView = toolBar
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        dateOfBirthField.text =  formatter.string(from: selectDatePicker.date)
    }
    
    func datePickerValueChanged (sender: UIDatePicker) {
        let cal = Calendar.current
        var min = DateComponents()
        var max = DateComponents()
        min.year = -100
        max.year = -10
        selectDatePicker.minimumDate = cal.date(byAdding: min, to: cal.startOfDay(for: Date()))
        selectDatePicker.maximumDate = cal.date(byAdding: max, to: cal.startOfDay(for: Date()))
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        dateOfBirthField.text =  formatter.string(from: sender.date)
        print(selectDatePicker.date)
    }
    
    func saveDob() {
        dateOfBirthField.resignFirstResponder()
    }
    
    func cancelSearch() {
        dateOfBirthField.text = ""
        dateOfBirthField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateOfBirthField.delegate = self
        firstnameField.delegate = self
        lastnameField.delegate = self
        locationField.delegate = self
        emailField.delegate = self
        telephoneField.delegate = self
        dateOfBirthField.delegate = self
        occupationField.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    func getPassword(message: String) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
