//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 21.03.2020.
//

import Foundation

public protocol ValidationGroup {
    associatedtype Value
    var values: [Value?] { get }
}

extension ValidationGroup {
    var values: [Value?] {
        let mirror = Mirror(reflecting: self)
        return mirror.children.map {
            if let wrapper = $0.value as? Validated<Value> {
                return wrapper.wrappedValue
            }
            if let value = $0.value as? Value {
                return value
            }
            return nil
        }
    }

}
