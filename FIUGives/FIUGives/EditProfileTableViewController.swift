//
//  EditProfileTableViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/6/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class EditProfileTableViewController: UITableViewController {
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var uploadPhoto: UIButton!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var occupationField: UITextField!
    @IBOutlet weak var aboutField: UITextView!
    @IBOutlet weak var filterEventsButton: UIButton!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var telephoneField: UITextField!
    @IBOutlet weak var managePasswordButton: UIButton!
    var rootRef = Database.database().reference()
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()
    
    @IBAction func saveUserProfile(_ sender: UIBarButtonItem) {
        // Input validation
        guard !(firstnameField.text!.isEmpty) && (firstnameField.text!.characters.count > 2) else {
            presentAlert(message: "Firstname must contain at least 2 characters")
            return
        }
        
        guard !(lastnameField.text!.isEmpty) && (lastnameField.text!.characters.count > 2) else {
            presentAlert(message: "Last name must contain at least 2 characters")
            return
        }
        
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
        
        if !(telephoneField.text!.isEmpty) {
            guard (Int(telephoneField.text!) != nil) else {
                presentAlert(message: "Please enter a valid phone number.")
                return
            }
        }
        
        // Update user object properties
        currentUser.userFirstName = firstnameField.text!
        currentUser.userLastName = lastnameField.text!
        currentUser.userOccupation = occupationField.text!
        currentUser.userAbout = aboutField.text!
        currentUser.userPhone = telephoneField.text!
        
        // Database update
        let userRef = rootRef.child("users")
        let newUserRef = userRef.child(userUID)
        newUserRef.setValue(currentUser.dictionaryObject())
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Get user information
    func getUser() {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userUID = Auth.auth().currentUser!.uid
        }
    }
    
    func getData() {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUser()

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
