//
//  MyEventsTableViewCell.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/17/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class MyEventsTableViewCell: UITableViewCell {

    @IBOutlet weak var eventName: UIButton!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var endDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
