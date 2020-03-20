//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct RegexValidator: Validator {
    public var errorMessage: String
    private var regex: String
    public init(regex: String, errorMessage: String) {
        self.regex = regex
        self.errorMessage = errorMessage
    }
    public func validate(value: String?) throws {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        if !predicate.evaluate(with: value) {
            throw ValidationError(message: errorMessage)
        }
    }
}
