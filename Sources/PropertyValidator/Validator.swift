//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public protocol Validator {
    associatedtype ValueType
    func validate(value: ValueType?) throws
}

public extension Validator {
    var validator: AnyValidator<ValueType> {
        AnyValidator(validator: self)
    }
}

public extension Validator {
    func next<V: Validator>(_ validator: V) -> SequenceValidator<V.ValueType> where V.ValueType == Self.ValueType {
        next([validator.validator])
    }
    
    func next(_ validators: [AnyValidator<ValueType>]) -> SequenceValidator<ValueType> {
        SequenceValidator(validators: [[self.validator], validators])
    }
}

private class ValidatorBox<T>: Validator {
    var errorMessage: String {
        fatalError()
    }
    
    func validate(value: T?) throws {
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
    
    override func validate(value: T?) throws {
        try validator.validate(value: value)
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
    
    public func validate(value: T?) throws {
        try validator.validate(value: value)
    }
}
