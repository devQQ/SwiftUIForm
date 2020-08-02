//
//  InputValidationSchema.swift
//  
//
//  Created by Q Trang on 8/1/20.
//

import Foundation

public class InputValidationSchema: ValidationSchema {
    public var value: Any
    public var publishers: [ValidationPublisher] = []
    
    public init(value: Any) {
        self.value = value
    }
    
    public func string() -> StringValidationSchema {
        let str = String(describing: value)
        return StringValidationSchema(value: str, publishers: publishers)
    }
}

