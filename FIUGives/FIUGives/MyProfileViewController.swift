//
//  MyProfileViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase

class MyProfileViewController: UITableViewController {
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    @IBOutlet weak var userDob: UILabel!
    @IBOutlet weak var userLocation: UILabel!

    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    
    // Get currently logged in user.
    func getUserAndCreateProfile() {
        var userUID = String()
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            userUID = Auth.auth().currentUser!.uid
            print("MY UID: \(userUID)")
        }
        
        /*ref = Database.database().reference()
        let userRef = ref.child("users").child(userUID)
        userRef.setValue(currentUser.dictionaryObject())
        print("THE CURRENT USER INFO: \(currentUser.dictionaryObject())")*/
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserAndCreateProfile()
        userName.text = currentUser.getUserFullName()
        userPhone.text = currentUser.userPhoneNumber
        userDob.text = currentUser.userDOB
        userLocation.text = currentUser.userLocation

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
