//
//  UserSignUpController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/4/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class UserSignUpController: UIViewController {
    @IBOutlet weak var userEmail: UITextField!
    @IBOutlet weak var userPassword: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var ref: DatabaseReference!
    
    
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
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
