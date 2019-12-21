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
    var validator: AnyValidator<ValueType> {
        AnyValidator(validator: self)
    }
}

extension Validator {
    func validate(value: ValueType?) throws {
        if !isValid(value: value) {
            throw ValidationError(message: errorMessage)
        }
    }
}

private class ValidatorBox<T>: Validator {
    var errorMessage: String {
        fatalError()
    }
    
    func isValid(value: T?) -> Bool {
        fatalError()
    }
}

private class ValidatorBoxHelper<T, V:Validator>: ValidatorBox<T> where V.ValueType == T {
    private let validator: V
    
    init(validator: V) {
        self.validator = validator
    }
    
    override var errorMessage: String {
        validator.errorMessage
    }
    
    override func isValid(value: T?) -> Bool {
        validator.isValid(value: value)
    }
}

public struct AnyValidator<T>: Validator {
    private let validator: ValidatorBox<T>
    
    public init<V: Validator>(validator: V) where V.ValueType == T {
        self.validator = ValidatorBoxHelper(validator: validator)
    }
    
    public var errorMessage: String {
        validator.errorMessage
    }
    
    public func isValid(value: T?) -> Bool {
        validator.isValid(value: value)
    }
}
