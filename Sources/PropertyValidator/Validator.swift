//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public protocol Validator {
    associatedtype ValueType
    var errorMessage: String { get }
    func isValid(value: ValueType?) -> Bool
}

public extension Validator {
    func validate(value: ValueType?) throws {
        if !isValid(value: value) {
            throw ValidationError(message: errorMessage)
        }
    }
}

public extension Validator {
    func eraseToAnyValidator() -> AnyValidator<ValueType> {
        AnyValidator(validator: self)
    }
}

class ValidatorBox<T>: Validator {
    var errorMessage: String {
        fatalError()
    }
    
    func isValid(value: T?) -> Bool {
        fatalError()
    }
}

class ValidatorBoxHelper<T, V:Validator>: ValidatorBox<T> where V.ValueType == T {
    
    private var validator: V
    
    override var errorMessage: String {
        validator.errorMessage
    }
    
    override func isValid(value: T?) -> Bool {
        validator.isValid(value: value)
    }
    
    init(validator: V) {
        self.validator = validator
    }
}

public struct AnyValidator<T>: Validator {
    private let validator: ValidatorBox<T>
    
    public var errorMessage: String {
        validator.errorMessage
    }
    
    init<V: Validator>(validator: V) where V.ValueType == T {
        self.validator = ValidatorBoxHelper(validator: validator)
    }
    
    public func isValid(value: T?) -> Bool {
        validator.isValid(value: value)
    }
}
