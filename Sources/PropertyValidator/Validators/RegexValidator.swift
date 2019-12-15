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
    public func isValid(value: String?) -> Bool {
        guard let v = value, !v.isEmpty else { return true } // Presents or NotNil validator should handle this
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: v)
    }
}
