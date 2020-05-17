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
    
    enum Step{
        case initial([AnyValidator<Value>])
        case and([AnyValidator<Value>])
        case or([AnyValidator<Value>])
    }

    
    var steps: [Step]

    init(validators: [AnyValidator<Value>]) {
        steps = [.initial(validators)]
    }
    
    public func validate(value: Value?) throws {
        loop: for (index, step) in steps.enumerated() {
            let errors = step.validators.compactMap { validator -> Error? in
              do {
                try validator.validate(value: value)
                return nil
              } catch {
                  return error
              }
            }
            let nextStep = index < steps.count - 1 ? steps[index + 1] : nil
            switch nextStep {
              case .none:
                if !errors.isEmpty { throw MultipleError(errors: errors) }
              case .and:
                if errors.isEmpty { continue } else { throw MultipleError(errors: errors) }
              case .or:
                if errors.isEmpty { break loop } else { continue }
              case .initial:
                fatalError()
              }
        }
    }
}

public extension Validator {
    func and(_ validators: [AnyValidator<ValueType>]) -> SequenceValidator<ValueType> {
        if var sequenceValidator = self as? SequenceValidator<ValueType> {
            sequenceValidator.steps.append(.and(validators))
            return sequenceValidator
        }

        return SequenceValidator(validators: [self.validator]).and(validators)
    }
    
    func and<V: Validator>(_ validator: V) -> SequenceValidator<ValueType> where V.ValueType == ValueType {
         and([validator.validator])
    }
    
    func or(_ validators: [AnyValidator<ValueType>]) -> SequenceValidator<ValueType> {
        if var sequenceValidator = self as? SequenceValidator<ValueType> {
            sequenceValidator.steps.append(.or(validators))
            return sequenceValidator
        }

        return SequenceValidator(validators: [self.validator]).or(validators)
    }
    
    func or<V: Validator>(_ validator: V) -> SequenceValidator<ValueType> where V.ValueType == ValueType {
        or([validator.validator])
    }
}

