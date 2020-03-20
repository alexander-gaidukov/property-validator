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
    
    public func validate(value: C?) throws {
        if !range.contains(value?.count ?? 0) {
            throw ValidationError(message: errorMessage)
        }
    }
}
