//
//  MyEventsViewController.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/27/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
import JTAppleCalendar

class MyEventsViewController: UIViewController {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    let formatter = DateFormatter()
    @IBOutlet weak var year: UILabel!
    @IBOutlet weak var month: UILabel!
    let Events = EventCalendar.shared.myCalendar
    let index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCalendarView()
    }
    
    // Calendar spacing
    func setUpCalendarView() {
        calendarView.scrollToDate(Date(), animateScroll: false)
        calendarView.selectDates([Date()])
        
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
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
        // Logic for color of days
        if cellState.dateBelongsTo == .thisMonth {
            trueCell.dateLabel.textColor = UIColor.darkGray
        } else {
            trueCell.dateLabel.textColor = UIColor.lightGray
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension MyEventsViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "YYYY MM dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2017 01 01")!
        let endDate = formatter.date(from: "2017 12 31")!
        
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
}

extension MyEventsViewController: JTAppleCalendarViewDelegate  {
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
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        setUpCellSelected(view: cell, cellState: cellState)
        setUpCellTextColor(view: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setUpCalendar(from: visibleDates)
    }
}
