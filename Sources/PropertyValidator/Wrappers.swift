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
    private var subject: Publishers.HandleEvents<PassthroughSubject<[ValidationError], Never>> {
        return _subject as! Publishers.HandleEvents<PassthroughSubject<[ValidationError], Never>>
    }
    
    private var subscribed: Bool = false
    private var validators: [AnyValidator<Value>]
    
    open var wrappedValue: Value? {
        didSet {
            if #available(iOS 13.0, *) {
                if subscribed {
                    subject.upstream.send(validate())
                }
            }
        }
    }
    
    public init(wrappedValue value: Value?, _ validators: [AnyValidator<Value>]) {
        wrappedValue = value
        self.validators = validators
        if #available(iOS 13.0, *) {
            _subject = PassthroughSubject<[ValidationError], Never>()
                .handleEvents(receiveSubscription: {[weak self] _ in
                self?.subscribed = true
            })
        }
    }
    
    open var projectedValue: Validated<Value> {
        self
    }
    
    @available(iOS 13.0, *)
    public var publisher: AnyPublisher<[ValidationError], Never> {
        subject.eraseToAnyPublisher()
    }
    
    public func validate() -> [ValidationError] {
        var errors: [ValidationError] = []
        validators.forEach {
            do {
                try $0.validate(value: wrappedValue)
            }
            catch {
                errors.append(error as! ValidationError)
            }
        }
        return errors
    }
}

