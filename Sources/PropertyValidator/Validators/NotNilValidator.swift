//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct NotNilValidator<Value>: Validator {
    public var errorMessage: String
    
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    public func validate(value: Value?) throws {
        if value == nil {
            throw ValidationError(message: errorMessage)
        }
    }
}
