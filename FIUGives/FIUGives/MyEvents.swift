//
//  MyEvents.swift
//  FIUGives
//
//  Created by Kathryn Bello on 6/12/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import UIKit

class MyEvents: UITableViewCell {

    @IBOutlet weak var eventName: UILabel!
    
    @IBOutlet weak var cancelButton: UIButton!
    
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
