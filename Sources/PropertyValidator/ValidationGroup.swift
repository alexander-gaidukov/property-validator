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
