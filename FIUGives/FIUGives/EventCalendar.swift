//
//  EventCalendar.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/8/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class EventCalendar {
    
    //MARL: properties
    var myCalendar: Array<Event>
    var size: Int
    
    //MARK: initialization
    init?() {
        self.myCalendar = Array()
        self.size = 0
    }
    
    //
    func addEvent(newEvent: Event) {
        self.myCalendar.append(newEvent)
        self.size += 1
    }
    
    
}
