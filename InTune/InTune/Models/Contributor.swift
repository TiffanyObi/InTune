//
//  Contributor.swift
//  InTune
//
//  Created by Oscar Victoria Gonzalez  on 8/5/20.
//  Copyright © 2020 Tiffany Obi. All rights reserved.
//

import Foundation

struct Contributor {
    let name: String
    let email: String
    let amountDonated: Double?
}

extension Contributor {

    init(_ dictionary:[String:Any]){
        self.name = dictionary["name"] as? String ?? "no name"
        self.email = dictionary["email"] as? String ?? "no email"
        self.amountDonated = dictionary["amountDonated"] as? Double ?? 0
    }

}
