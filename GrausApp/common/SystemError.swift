//
//  SystemError.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//


struct SystemError: Error {
    let message: String
    let file: StaticString
    let line: UInt
    init(_ message: String, file: StaticString = #file, line: UInt = #line) {
        self.message = message
        self.file = file
        self.line = line
    }
}
