//
//  EventDetailsViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventContactEmail: UILabel!
    @IBOutlet weak var eventContact: UILabel!
    @IBOutlet weak var eventStart: UILabel!
    @IBOutlet weak var eventEnd: UILabel!
    @IBOutlet weak var eventDesc: UITextView!
    @IBOutlet weak var eventLoc: UITextView!
    @IBOutlet weak var eventFlyer: UILabel!
    @IBOutlet weak var rsvpButton: UIButton!
    
    
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
