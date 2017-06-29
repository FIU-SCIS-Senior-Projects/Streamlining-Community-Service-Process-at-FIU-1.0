//
//  EventsViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: IBOutlets
   
    @IBOutlet weak var eventsTable: UITableView!

    
    override func viewDidLoad() {

     
   super.viewDidLoad()
    
        
        //eventsTableView.dataSource = self
        //eventsTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        self.eventsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventCalendar.shared.totalEvents()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, h:mm a"
        
        
        cell.textLabel?.text = formatter.string(from: EventCalendar.shared.myCalendar[indexPath.row].eventStart as Date)
        cell.detailTextLabel?.text = EventCalendar.shared.myCalendar[indexPath.row].eventName
        return cell
        
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
