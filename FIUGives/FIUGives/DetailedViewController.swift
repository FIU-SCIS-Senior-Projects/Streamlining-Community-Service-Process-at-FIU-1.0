//
//  DetaledViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 7/2/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class DetailedViewController: UIViewController {
    var detailedEvent:Event?

    @IBOutlet weak var detailedEventName: UILabel!
  
    
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    detailedEventName.text = detailedEvent?.eventName
        
    

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
