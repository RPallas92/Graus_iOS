//
//  Day.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

typealias Day = Date

extension Day {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
}
