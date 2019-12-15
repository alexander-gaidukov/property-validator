//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct NotEmptyValidator<C: Collection>: Validator {
    public var errorMessage: String
    
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    
    public func isValid(value: C?) -> Bool {
        value?.isEmpty == false
    }
}
