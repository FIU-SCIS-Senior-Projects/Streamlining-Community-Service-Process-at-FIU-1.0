//
//  FilterEventsViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import MapKit

class EditEventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var userEventsCreatedTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return User.sharedInstance.userEventsCreated.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "editEventCell", for: indexPath)
        let formatter = DateFormatter()
        let event = User.sharedInstance.userEventsCreated[indexPath.row]
        formatter.dateFormat = "MMM d, h:mm a"
        cell.textLabel?.text = event.eventName
        cell.detailTextLabel?.text = formatter.string(from: event.eventStart)
        return cell

    }

  

}
