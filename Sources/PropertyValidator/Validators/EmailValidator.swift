//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct EmailValidator: Validator {
    public var errorMessage: String
    public init(errorMessage: String) {
        self.errorMessage = errorMessage
    }
    public func isValid(value: String?) -> Bool {
        guard let email = value, !email.isEmpty else { return true } // Presents or NotNil validator should handle this
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: email)
    }
}
