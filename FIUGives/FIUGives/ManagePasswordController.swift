//
//  ManagePasswordController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 7/15/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class ManagePasswordController: UIViewController {
    @IBOutlet weak var currentPW: UITextField!
    @IBOutlet weak var newPW: UITextField!
    @IBOutlet weak var confirmPW: UITextField!
    var ref = Database.database().reference()
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    
    @IBAction func savePW(_ sender: UIBarButtonItem) {
        
        guard !(newPW.text?.isEmpty)! && (newPW.text?.characters.count)! >= 6 else {
            presentAlert(message: "Password needs to be at least 6 characters.")
            return
        }
        
        guard !(confirmPW.text?.isEmpty)! && (confirmPW.text)! == newPW.text else {
            presentAlert(message: "Passwords entered do not match.")
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: self.currentPW.text!)
        Auth.auth().currentUser?.reauthenticate(with: credential) { error in
            if error != nil {
                self.presentAlert(message: "Current password is not recognized.")
            } else {
                print("Successful authentication with original password.")
                Auth.auth().currentUser?.updatePassword(to: self.newPW.text!) { (error) in
                    if let error = error {
                        self.presentAlert(message: error.localizedDescription)
                        return
                    } else {
                        print("Successful Password Change.")
                        let credential = EmailAuthProvider.credential(withEmail: (Auth.auth().currentUser?.email)!, password: self.newPW.text!)
                        Auth.auth().currentUser?.reauthenticate(with: credential) { error in
                            if error != nil {
                                self.presentAlert(message: (error?.localizedDescription)!)
                                return
                            } else {
                                print("Successfully reauthenticated.")
                                self.presentAlert(message: "Password was successfully changed.")
                            }
                        }
                    }
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func forgotPW(_ sender: UIButton) {
        Auth.auth().sendPasswordReset(withEmail: (Auth.auth().currentUser?.email)!) { (error) in
            self.presentAlert(message: "You should receive a reset password email shortly.")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Alert controller
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .destructive)
        alertController.addAction(okAction)
        present(alertController, animated: true)
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
