//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct LengthValidator<R: RangeExpression, C: Collection>: Validator where R.Bound == Int {
    var range: R
    public var errorMessage: String
    
    public init(range: R, errorMessage: String) {
        self.range = range
        self.errorMessage = errorMessage
    }
    
    public func isValid(value: C?) -> Bool {
        guard let count = value?.count, count > 0 else { return true } // NotEmpty or NotNil validators should cover this case
        if range.contains(value?.count ?? 0) {
            return true
        }
        
        return false
    }
}
