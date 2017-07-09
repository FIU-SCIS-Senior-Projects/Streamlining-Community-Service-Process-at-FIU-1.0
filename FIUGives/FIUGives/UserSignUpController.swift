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
    @IBOutlet weak var userPhoneNumber: UITextField?
    @IBOutlet weak var userDOB: UITextField?
    @IBOutlet weak var userLocation: UITextField?
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
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
        
        /* Validation for numbers in telephone and dob fields.
        if !((userPhoneNumber?.text!.isEmpty)!) || !((userDOB?.text?.isEmpty)!) {
            guard (Int((userPhoneNumber?.text!)!) != nil) else {
                presentAlert(message: "Please enter a valid phone number.")
                return
            }
            
            guard (Int((userDOB?.text!)!) != nil) else {
                presentAlert(message: "Please enter a valid date of birth.")
                return
            }
        } */
        
        self.userEmail.resignFirstResponder()
        self.userPassword.resignFirstResponder()
        self.passwordConfirm.resignFirstResponder()
        self.userDOB?.resignFirstResponder()
        self.userLocation?.resignFirstResponder()
        self.userFirstName.resignFirstResponder()
        self.userLastName.resignFirstResponder()
        self.userPhoneNumber?.resignFirstResponder()
        
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
        print("THE CURRENT USER OBJECT: \(currentUser.userFirstName) \(currentUser.userLastName) \(currentUser.userPhoneNumber) \(currentUser.userDOB) \(currentUser.userLocation)")
    }
    
    // Textfield formatting for dob and phone number.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == userDOB {
            if (userDOB?.text?.characters.count == 2) || (userDOB?.text?.characters.count == 5) {
                if !(string == "") {
                    userDOB?.text = (userDOB?.text)! + "-"
                }
            }
            return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
        } else if textField == userPhoneNumber {
            if (userPhoneNumber?.text?.characters.count == 3) || (userPhoneNumber?.text?.characters.count == 7) {
                if !(string == "") {
                    userPhoneNumber?.text = (userPhoneNumber?.text)! + "-"
                }
            }
                return !(textField.text!.characters.count > 11 && (string.characters.count ) > range.length)
        } else {
            return true
        }
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
        userPhoneNumber?.delegate = self
        // getUser()
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
