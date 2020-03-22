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
        var result = [Value?]()
        for child in mirror.children {
            if let value = child.value as? Value? {
                result.append(value)
            }
        }
        return result
    }
}
