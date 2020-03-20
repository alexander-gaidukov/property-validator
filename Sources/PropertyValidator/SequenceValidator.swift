//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 20.03.2020.
//

import Foundation

struct MultipleError: Error {
    var errors: [Error]
}

public struct SequenceValidator<Value>: Validator {
    private var validators: [[AnyValidator<Value>]]
    
    init(validators: [[AnyValidator<Value>]]) {
        self.validators = validators
    }
    
    public func validate(value: Value?) throws {
        for validatorGroup in validators {
            let errors = validatorGroup.compactMap { validator -> Error? in
                do {
                    try validator.validate(value: value)
                    return nil
                } catch {
                    return error
                }
            }
            
            if !errors.isEmpty {
                throw MultipleError(errors: errors)
            }
        }
    }
}

public extension SequenceValidator {
    func next<V: Validator>(_ validator: V) -> SequenceValidator<Value> where V.ValueType == Value {
        next([validator.validator])
    }
    
    func next(_ validators: [AnyValidator<Value>]) -> SequenceValidator<Value> {
        var result = self
        result.validators.append(validators)
        return result
    }
}
