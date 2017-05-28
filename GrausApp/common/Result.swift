//
//  Result.swift
//  GrausApp
//
//  Created by Pallas, Ricardo on 5/6/17.
//  Copyright © 2017 Pallas, Ricardo. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case failure(E)
}

extension Result where T : Array<Any> {
    
    func hackconcat(otherResult: Result) -> Result{
        
        switch self {
        case .success(let t):
            switch otherResult {
            case .success(let otherT):
                return Result.success(t + otherT)
            case .failure( _):
                return otherResult
            }
        case .failure( _):
            return self
        }
    }
}

extension Result {
    func getHack() -> String {
        return "HAck"
    }
}
