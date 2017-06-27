//
//  MyEventsTableViewCell.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/17/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class MyEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // eventName.text = eventsRsvp[myIndex].eventName
        
        // Testing
        eventName.text = eventsRsvp[myIndex]
        
        // startDate.text = formatter.string(from: eventsRsvp[indexPath.row].eventStart as Date)
        // eventDate.text = formatter.string(from: eventsRsvp[indexPath.row].eventEnd as Date)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
