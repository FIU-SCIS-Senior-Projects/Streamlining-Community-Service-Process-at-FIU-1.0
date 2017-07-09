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
    @IBOutlet weak var locationField: UITextField?
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephoneField: UITextField?
    @IBOutlet weak var dateOfBirthField: UITextField?
    @IBOutlet weak var managePasswordButton: UIButton!
    // Database connection
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()
    
    @IBAction func saveUserProfile(_ sender: UIBarButtonItem) {
        // Validation for email format.
        if !(emailField.text!.isEmpty) {
            guard (emailField.text!.contains("@")) else {
                presentAlert(message: "Please enter a valid email address.")
                return
            }
            
            // Update email
            Auth.auth().currentUser?.updateEmail(to: emailField.text!) { (error) in
                if let error = error {
                    self.presentAlert(message: error.localizedDescription)
                    return
                } else {
                    print("Successful Email Change")
                    // Add email confirmation
                }
            }
        }
        
        /* Validation for numbers in telephone field.
        if !((telephoneField?.text!.isEmpty)!) {
            guard (Int((telephoneField?.text!)!) != nil) else {
                presentAlert(message: "Please enter a valid phone number.")
                return
                
            }
        } */
        
        // Update user object properties
        if currentUser.userFirstName != firstnameField.text! && !(firstnameField.text!.isEmpty) {
            currentUser.userFirstName = firstnameField.text!
        }
        if currentUser.userLastName != lastnameField.text! && !(lastnameField.text!.isEmpty) {
            currentUser.userLastName = lastnameField.text!
        }
        if currentUser.userLocation != (locationField?.text!)! && !((locationField?.text?.isEmpty)!) {
            currentUser.userLocation = (locationField?.text!)!
        }
        if currentUser.userDOB != (dateOfBirthField?.text!)! && !((dateOfBirthField?.text?.isEmpty)!) {
            currentUser.userDOB = (dateOfBirthField?.text!)!
        }
        if currentUser.userPhoneNumber != (telephoneField?.text!)! && !((telephoneField?.text?.isEmpty)!) {
            currentUser.userPhoneNumber = (telephoneField?.text!)!
        }
        
        /* Database update
        ref = Database.database().reference()
        let key = ref.child("users").childByAutoId().key
        let post = [
            "Firstname": firstnameField.text!,
            "Lastname": lastnameField.text!,
            "DOB": dateOfBirthField?.text!,
            "Location": locationField?.text!,
            "Phone": telephoneField?.text!
        ]
        let childUpdates = ["/posts/\(key)": post,
                            "/user-posts/\(userUID)/\(key)/": post]
        ref.updateChildValues(childUpdates) */
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Get user information
    func getUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userUID = Auth.auth().currentUser!.uid
            print("CURRENT USER UID: \(self.userUID)")
        }
    }
    
    // Textfield formatting for dob and phone number.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == dateOfBirthField {
            if (dateOfBirthField?.text?.characters.count == 2) || (dateOfBirthField?.text?.characters.count == 5) {
                if !(string == "") {
                    dateOfBirthField?.text = (dateOfBirthField?.text)! + "-"
                }
            }
            return !(textField.text!.characters.count > 9 && (string.characters.count ) > range.length)
        } else if textField == telephoneField {
            if (telephoneField?.text?.characters.count == 3) || (telephoneField?.text?.characters.count == 7) {
                if !(string == "") {
                    telephoneField?.text = (telephoneField?.text)! + "-"
                }
            }
            return !(textField.text!.characters.count > 11 && (string.characters.count ) > range.length)
        } else {
            return true
        }
    }
    
    func getData() {
        print(userUID)
        ref = Database.database().reference()
        let userRef = ref.child("users").child(userUID)
            userRef.observeSingleEvent(of: .value, with: { snapshot in
                if !snapshot.exists() { return }
                print(snapshot.value)
                let value = snapshot.value as? NSDictionary
                
                let firstname = value?["Firstname"] as? String ?? ""
                let lastname = value?["Lastname"] as? String ?? ""
                let dob = value?["DOB"] as? String ?? ""
                let phone = value?["Phone"] as? String ?? ""
                let location = value?["Location"] as? String ?? ""
                print("\(firstname) \(lastname) \(dob) \(phone) \(location)")
                
                // Update user object properties
                self.currentUser.userFirstName = firstname
                self.currentUser.userLastName = lastname
                self.currentUser.userLocation = location
                self.currentUser.userDOB = dob
                self.currentUser.userPhoneNumber = phone
            })
        /*
    rootRef.child("users").child(userUID).observe(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            print(snapshot.value)
            
            let firstname = value?["Firstname"] as? String ?? ""
            let lastname = value?["Lastname"] as? String ?? ""
            let dob = value?["DOB"] as? String ?? ""
            let phone = value?["Phone"] as? String ?? ""
            let location = value?["Location"] as? String ?? ""
            print("\(firstname) \(lastname) \(dob) \(phone) \(location)")
            
            // Update user object properties
            self.currentUser.userFirstName = firstname
            self.currentUser.userLastName = lastname
            self.currentUser.userLocation = location
            self.currentUser.userDOB = dob
            self.currentUser.userPhoneNumber = phone
        }) } (error) in
            print(error.localizedDescription)
        }
    } */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()
        dateOfBirthField?.delegate = self
        telephoneField?.delegate = self
        // getData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
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
