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
open class Validated<Value> {
    
    private var _subject: Any!
    
    @available(iOS 13.0, *)
    private var subject: Publishers.HandleEvents<PassthroughSubject<[Error], Never>> {
        return _subject as! Publishers.HandleEvents<PassthroughSubject<[Error], Never>>
    }
    
    private var subscribed: Bool = false
    private var validators: [AnyValidator<Value>]
    
    open var wrappedValue: Value? {
        didSet {
            if #available(iOS 13.0, *) {
                if subscribed {
                    subject.upstream.send(errors)
                }
            }
        }
    }
    
    public init(wrappedValue value: Value?, _ validators: [AnyValidator<Value>]) {
        wrappedValue = value
        self.validators = validators
        if #available(iOS 13.0, *) {
            _subject = PassthroughSubject<[Error], Never>()
                .handleEvents(receiveSubscription: {[weak self] _ in
                self?.subscribed = true
            })
        }
    }
    
    open var projectedValue: Validated<Value> {
        self
    }
    
    @available(iOS 13.0, *)
    public var publisher: AnyPublisher<[Error], Never> {
        subject.eraseToAnyPublisher()
    }
    
    public var errors: [Error] {
        var errors: [Error] = []
        validators.forEach {
            do {
                try $0.validate(value: wrappedValue)
            }
            catch {
                if let multipleError = error as? MultipleError {
                    errors.append(contentsOf: multipleError.errors)
                } else {
                    errors.append(error)
                }
            }
        }
        return errors
    }
}

