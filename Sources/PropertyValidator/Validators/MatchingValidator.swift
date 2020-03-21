//
//  MatchingValidator.swift
//  
//
//  Created by Alexandr Gaidukov on 21.03.2020.
//

import Foundation

public struct MatchingValidator<Group: ValidationGroup>: Validator where Group.Value: Equatable {
    public var errorMessage: String
    
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    public func validate(value: Group?) throws {
        guard let values = value?.values, values.count > 1 else { return }
        for i in 1..<values.count {
            if values[i - 1] != values[i] {
                throw ValidationError(message: errorMessage)
            }
        }
    }
}
