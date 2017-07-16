//
//  MyProfileViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userDob: UILabel!
    @IBOutlet weak var userLocation: UILabel!
    @IBOutlet weak var userOccupation: UILabel!
    @IBOutlet weak var userEmail: UIButton!
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()
    
    func getUser() {
        // Get current user
        self.handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userUID = Auth.auth().currentUser!.uid
        }
    
        // Get user database information.
        let ref = Database.database().reference()
        ref.child("users").child(Auth.auth().currentUser!.uid).observe(.value, with: { (snapshot) in
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
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        self.userName.text! = self.currentUser.getUserFullName().capitalized
        self.userEmail.setTitle((Auth.auth().currentUser?.email)!, for: .normal)
        self.userPhone.text! = self.currentUser.userPhoneNumber
        self.userDob.text! = self.currentUser.userDOB
        self.userLocation.text! = self.currentUser.userLocation.capitalized
        self.userOccupation.text! = self.currentUser.userOccupation.capitalized
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func contactEmailPressed(_ sender: UIButton) {
        if let url = URL(string: "mailto:\(userEmail.currentTitle)") {
            UIApplication.shared.open(url)
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
