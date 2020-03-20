//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct ValidationError: LocalizedError {
    private var message: String
    
    public init(message: String) {
        self.message = message
    }
    public var errorDescription: String? {
        message
    }
}
