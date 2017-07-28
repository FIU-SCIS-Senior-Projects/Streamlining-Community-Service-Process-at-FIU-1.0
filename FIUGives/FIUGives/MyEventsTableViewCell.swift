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
    @IBOutlet weak var eventDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
