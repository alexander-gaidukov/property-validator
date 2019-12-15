//
//  File.swift
//  
//
//  Created by Alexandr Gaidukov on 08.12.2019.
//

import Foundation

public struct ValidationError: LocalizedError {
    var message: String
    public var errorDescription: String? {
        message
    }
}
