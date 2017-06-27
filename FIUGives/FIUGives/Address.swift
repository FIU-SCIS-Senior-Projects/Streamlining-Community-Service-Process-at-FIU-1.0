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
    let space = " "
    
    func fullAddress() -> String {
        return street + space + city + space + state + space + zip
    }
    
    
    
    
}
