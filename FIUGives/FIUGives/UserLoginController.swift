
//
//  UserLoginController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/4/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class UserLoginController: UIViewController {
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()
    
    @IBAction func forgotPasswordPressed(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { (error) in
            self.presentAlert(message: "You should receive a reset password email shortly.")
        }
    }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Signup")
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        passwordField.isSecureTextEntry = true
        guard !(emailField.text!.isEmpty) || !(passwordField.text?.isEmpty)! else {
            self.presentAlert(message: "Please enter an email or password")
            return
        }
        
        self.emailField.resignFirstResponder()
        self.passwordField.resignFirstResponder()
        
        passwordField.isSecureTextEntry = true
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (user, error) in
            if let error = error {
                self.presentAlert(message: error.localizedDescription)
                return
            } else {
                print("Successful Login")
                
                // Get current user
                self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
                    self.userUID = Auth.auth().currentUser!.uid
                }
                
                // Get user database information.
                let ref = Database.database().reference()
                ref.child("users").child("user-info").child(Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
                    let value = snapshot.value as? [String:AnyObject]
                    if let first = value?["Firstname"] as? String {
                        self.currentUser.userFirstName = first
                    }
                    if let last = value?["Lastname"] as? String {
                        self.currentUser.userLastName = last
                    }
                    if let loc = value?["Location"] as? String {
                        self.currentUser.userLocation = loc
                    }
                    if let phone = value?["Phone"] as? String {
                        self.currentUser.userPhoneNumber = phone
                    }
                    if let dob = value?["DOB"] as? String {
                        self.currentUser.userDOB = dob
                    }
                    if let occupation = value?["Occupation"] as? String {
                        self.currentUser.userOccupation = occupation
                    }
                        
                    }) { (error) in
                        print(error.localizedDescription)
                    }
                
                UserDatabase.sharedInstance.getRsvpList()
                }
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Main")
                self.present(vc!, animated: true, completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        self.present(alertController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    } */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
