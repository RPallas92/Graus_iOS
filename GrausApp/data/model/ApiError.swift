//
//  ApiError.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

enum ApiError: Error {
    case offline
    case serverError
    case internalError
}
