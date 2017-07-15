//
//  EventsViewController.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/11/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import Firebase


class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    let dataBaseReference = Database.database().reference(withPath: "eventCalendar")
    var eventCapacity: Int?
    var eventAddress: Address?
    var newEvent: Event?
    
    //MARK: IBOutlets
    @IBOutlet weak var eventsTable: UITableView!
    //get the keys from the EventCalendar dictionary & sort them
    var eventDates = Array(EventCalendar.shared.myCalendar.keys)

    
   override func viewDidLoad() {
   super.viewDidLoad()
    /*
     refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
     let postDict = snapshot.value as? [String : AnyObject] ?? [:]
     // ...
     })
     */
    
    
    
    
       /* dataBaseReference.child("eventCalendar").observe(.value, with: { (snapshot) in
            if snapshot.hasChildren() {
                print("yes")
            }
            else {
                print("no")
            }
            
        })*/
    
        
        
        //let a = snapshot.value!["eventName"] as! String
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        eventDates = Array(EventCalendar.shared.myCalendar.keys)
        eventDates.sort()
        self.eventsTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return eventDates.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (EventCalendar.shared.myCalendar[eventDates[section]]?.count)!
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return eventDates[section].dateComponent()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath)
        let formatter = DateFormatter()
        let event = EventCalendar.shared.myCalendar[eventDates[indexPath.section]]?[indexPath.row]
        formatter.dateFormat = "h:mm a"
        cell.textLabel?.text = formatter.string(from: (event?.eventStart)!)
        cell.detailTextLabel?.text = event?.eventName
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = EventCalendar.shared.myCalendar[eventDates[indexPath.section]]?[indexPath.row]
        performSegue(withIdentifier: "detailedViewSegue", sender: event)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailedViewSegue" {
        let destination = segue.destination as! DetailedViewController
        destination.detailedEvent = sender as? Event
        }
    }

    
    

}
