//
//  EventDate.swift
//  FIUGives
//
//  Created by Katya Gumnova on 7/1/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit
class EventDate: Hashable, Comparable {
    var myEventDate = Date()
    
    init (myEventDate:Date) {
        let cal = Calendar.current
        self.myEventDate = cal.startOfDay(for: myEventDate)
    }
    var hashValue: Int {
        return Int(self.myEventDate.timeIntervalSinceReferenceDate)
    }
    static func == (lhs: EventDate, rhs: EventDate) -> Bool {
        return lhs.myEventDate == rhs.myEventDate
    }
    static func < (lhs: EventDate, rhs: EventDate) -> Bool {
        if (lhs.myEventDate.compare(rhs.myEventDate) == .orderedAscending) {
            return true
        }
        return false
    }
    func dateComponent() -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MMM d, yyyy"
        return formatter.string(from: self.myEventDate)
    }
    
}
