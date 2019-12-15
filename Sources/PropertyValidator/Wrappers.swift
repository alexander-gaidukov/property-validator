//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

#if canImport(Combine)
import Combine
#endif
import Foundation

@propertyWrapper
public final class Validated<Value> {
    #if swift(>=13.0)
    private var subject: Publishers.HandleEvents<PassthroughSubject<[ValidationError], Never>>!
    private var subscribed: Bool = false
    #endif
    private var validators: [AnyValidator<Value>]
    
    public var wrappedValue: Value? {
        didSet {
            #if swift(>=13.0)
            if subscribed {
                subject.upstream.send(validate())
            }
            #endif
        }
    }
    
    public init(wrappedValue value: Value?, _ validators: [AnyValidator<Value>]) {
        wrappedValue = value
        self.validators = validators
        #if swift(>=13.0)
        subject = PassthroughSubject<[ValidationError], Never>()
            .handleEvents(receiveSubscription: {[weak self] _ in
            self?.subscribed = true
        })
        #endif
    }
    
    #if swift(>=13.0)
    var projectedValue: AnyPublisher<[ValidationError], Never> {
        subject.eraseToAnyPublisher()
    }
    #endif
    
    func validate() -> [ValidationError] {
        var errors: [ValidationError] = []
        validators.forEach {
            do {
                try $0.validate(value: wrappedValue)
            }
            catch {
                if let validationError = error as? ValidationError {
                    errors.append(validationError)
                }
            }
        }
        return errors
    }
}

