//
//  UserSignUpController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/4/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class UserSignUpController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var userFirstName: UITextField!
    @IBOutlet weak var userLastName: UITextField!
    @IBOutlet weak var userPhoneNumber: UITextField!
    @IBOutlet weak var userDOB: UITextField!
    @IBOutlet weak var userLocation: UITextField!
    @IBOutlet weak var userOccupation: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    let selectDatePicker = UIDatePicker()
    var rootRef = Database.database().reference()
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()
    
    @IBAction func loginButtonPressed(_ sender: AnyObject) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func signupButtonPressed(_ sender: AnyObject) {
        guard !(userEmail.text!.isEmpty) && (userEmail.text!.contains("@")) else {
            presentAlert(message: "Please enter a valid email address.")
            return
        }
        
        guard !(userPassword.text?.isEmpty)! && (userPassword.text?.characters.count)! >= 6 else {
            self.presentAlert(message: "Password needs to be at least 6 characters.")
            return
        }
        
        guard !(passwordConfirm.text?.isEmpty)! && (passwordConfirm.text)! == userPassword.text else {
            self.presentAlert(message: "Passwords entered do not match.")
            return
        }
        
        guard !(userFirstName.text!.isEmpty) && (userFirstName.text!.characters.count > 2) else {
            presentAlert(message: "Firstname must contain at least 2 characters")
            return
        }
        
        guard !(userLastName.text!.isEmpty) && (userLastName.text!.characters.count > 2) else {
            presentAlert(message: "Last name must contain at least 2 characters")
            return
        }
        
        // Validation for numbers in telephone.
        if !((userPhoneNumber?.text!.isEmpty)!) || !((userDOB?.text?.isEmpty)!) {
            guard (Int((userPhoneNumber?.text!)!) != nil) else {
                presentAlert(message: "Please enter a valid phone number.")
                return
            }
        }
        
        self.userEmail.resignFirstResponder()
        self.userPassword.resignFirstResponder()
        self.passwordConfirm.resignFirstResponder()
        self.userDOB.resignFirstResponder()
        self.userLocation.resignFirstResponder()
        self.userFirstName.resignFirstResponder()
        self.userLastName.resignFirstResponder()
        self.userPhoneNumber.resignFirstResponder()
        self.userOccupation.resignFirstResponder()
        
        self.userPassword.isSecureTextEntry = true
        self.passwordConfirm.isSecureTextEntry = true
        
        // Create user with email.
        Auth.auth().createUser(withEmail: userEmail.text!, password: userPassword.text!) { (user, error) in
            if let error = error {
                self.presentAlert(message: error.localizedDescription)
                return
            } else {
                print("Successful Login")
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                self.present(vc!, animated: true, completion: nil)
            }
        }
        
        // Update user object properties
        currentUser.userFirstName = userFirstName.text!
        currentUser.userLastName = userLastName.text!
        currentUser.userDOB = (userDOB?.text)!
        currentUser.userPhoneNumber = (userPhoneNumber?.text)!
        currentUser.userLocation = (userLocation?.text)!
        currentUser.userOccupation = (userOccupation.text)!
        print("THE CURRENT USER OBJECT: \(currentUser.userFirstName) \(currentUser.userLastName) \(currentUser.userPhoneNumber) \(currentUser.userDOB) \(currentUser.userLocation) \(currentUser.userOccupation)")
    }
    
    // Date picker for user date of birth.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectDatePicker.datePickerMode = UIDatePickerMode.date
        selectDatePicker.backgroundColor = UIColor.white
        textField.inputView = selectDatePicker
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
        textField.inputAccessoryView = toolBar
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        userDOB?.text =  formatter.string(from: selectDatePicker.date)
    }
    
    func datePickerValueChanged (sender: UIDatePicker) {
        var components = DateComponents()
        components.year = -100
        let min = Calendar.current.date(byAdding: components, to: Date())
        let max = Date()
        sender.minimumDate = min
        sender.maximumDate = max
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/YYYY"
        userDOB?.text =  formatter.string(from: sender.date)
        print(selectDatePicker.date)
    }
    
    func saveDob() {
        userDOB?.resignFirstResponder()
    }
    
    func cancelSearch() {
        userDOB?.text = ""
        userDOB?.resignFirstResponder()
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    // Hide keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userDOB?.delegate = self
        // Do any additional setup after loading the view.
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
