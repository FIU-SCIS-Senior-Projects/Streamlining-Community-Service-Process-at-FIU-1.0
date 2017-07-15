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
    var ref: DatabaseReference!
    var handle: AuthStateDidChangeListenerHandle? = nil
    var currentUser = User.sharedInstance
    var userUID = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: .zero)
        self.userName.text! = self.currentUser.getUserFullName().capitalized
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
