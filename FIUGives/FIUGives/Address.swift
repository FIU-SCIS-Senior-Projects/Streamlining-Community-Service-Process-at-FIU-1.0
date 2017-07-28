//
//  Address.swift
//  FIUGives
//
//  Created by Katya Gumnova on 6/27/17.
//  Copyright © 2017 FIUGives. All rights reserved.
//

import Foundation
struct Address {
    var street:String
    var city: String
    var state: String
    var zip: String
    
    func fullAddress() -> String {
        return "\(street) \n\(city), \(state), \(zip), USA"
  
    }
    
}
