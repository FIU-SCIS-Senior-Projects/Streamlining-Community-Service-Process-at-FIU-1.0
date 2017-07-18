//
//  MyEventsViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/27/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MyEventsViewController: UIViewController, JTAppleCalendarViewDataSource, JTAppleCalendarViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    @IBOutlet weak var tableView: UITableView!
    let formatter = DateFormatter()
    let aFormatter = DateFormatter()
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    var noEvents = [Any]()
    var eventsForDate = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        calendarView.reloadData()
    }

    // Calendar spacing
    func setUpCalendarView() {
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
    }
    
    // Fetch Events from eventDates array
    func getEventsForDate(view: JTAppleCell?, cellState: CellState) {
        if !(User.sharedInstance.userRsvpEvents.isEmpty) {
            if User.sharedInstance.userRsvpEvents.keys.contains(EventDate.init(myEventDate: cellState.date)) {
                for item in User.sharedInstance.userRsvpEvents[EventDate.init(myEventDate: cellState.date)]! {
                    eventsForDate.append(item)
                }
            } else {
                eventsForDate = noEvents as! [Event]
            }
        } else {
            eventsForDate = noEvents as! [Event]
        }
    }
    
    func setUpCellSelected(view: JTAppleCell?, cellState: CellState) {
        guard let trueCell = view as? CalendarCell else { return }
        // Logic for selecting the cell
        if cellState.isSelected {
            trueCell.selectedView.isHidden = false
        } else {
            trueCell.selectedView.isHidden = true
        }
    }
    
    func setUpCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        formatter.dateFormat = "YYYY"
        year.text = formatter.string(from: date)
        formatter.dateFormat = "MMMM"
        month.text = formatter.string(from: date)
    }
    
    func setUpCellTextColor(view: JTAppleCell?, cellState: CellState) {
        guard let trueCell = view as? CalendarCell else { return }
        
        for item in eventsForDate {
            if item.eventDate == EventDate.init(myEventDate: cellState.date) {
                trueCell.eventView.isHidden = false
            }
        }
        
        // Logic for color of days
        if cellState.dateBelongsTo == .thisMonth {
            if cellState.isSelected {
                trueCell.dateLabel.textColor = UIColor.white
            } else {
                trueCell.dateLabel.textColor = UIColor.darkGray
            }
        } else {
            if cellState.isSelected {
                trueCell.dateLabel.textColor = UIColor.white
            } else {
                trueCell.dateLabel.textColor = UIColor.lightGray
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "YYYY MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
    
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    
    // Display the cell
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CalendarCell", for: indexPath) as! CalendarCell
        cell.dateLabel.text = cellState.text
        setUpCellSelected(view: cell, cellState: cellState)
        setUpCellTextColor(view: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        setUpCellSelected(view: cell, cellState: cellState)
        setUpCellTextColor(view: cell, cellState: cellState)
        print(formatter.string(from: date))
        getEventsForDate(view: cell, cellState: cellState)
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        setUpCellSelected(view: cell, cellState: cellState)
        setUpCellTextColor(view: cell, cellState: cellState)
        eventsForDate.removeAll()
        self.tableView.reloadData()
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendar(from: visibleDates)
        self.tableView.reloadData()
    }

    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsForDate.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rsvpCell", for: indexPath) as! MyEventsTableViewCell
        let event = eventsForDate[indexPath.row]
        formatter.dateFormat = "hh:mm aa"
        aFormatter.dateFormat = "MMMM dd, YYYY"
        cell.eventName.text = event.eventName
        let start = formatter.string(from: event.eventStart)
        let end = formatter.string(from: event.eventEnd)
        cell.eventDate.text = ("\(start) - \(end)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let event = eventsForDate[indexPath.row]
        performSegue(withIdentifier: "eventDetailsSegue", sender: event)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "eventDetailsSegue" {
            let destination = segue.destination as! DetailedViewController
            destination.detailedEvent = sender as? Event
        }
    }
}
