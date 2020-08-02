//
//  Published.Publisher+Validators.swift
//  
//
//  Created by Q Trang on 8/1/20.
//

import Foundation
import Combine

extension Published.Publisher where Value == String {
    public func digitsOnlyValidation(message: String? = nil) -> ValidationPublisher {
        self.flatMap({ (value) -> ValidationPublisher in
            InputValidationSchema(value: value)
                .string()
                .required(message)
                .matches(NSRegularExpression.digitsOnly, message: message)
                .validate()
        })
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    public func emailValidation(message: String? = StringValidationSchema.Message.email) -> ValidationPublisher {
        self.flatMap({ (value) -> ValidationPublisher in
            InputValidationSchema(value: value)
                .string()
                .required(message)
                .email()
                .validate()
        })
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    public func lettersOnlyValidation(message: String? = nil) -> ValidationPublisher {
        self.flatMap({ (value) -> ValidationPublisher in
            InputValidationSchema(value: value)
                .string()
                .required(message)
                .matches(NSRegularExpression.lettersOnly, message: message)
                .validate()
        })
            .dropFirst()
            .eraseToAnyPublisher()
    }
    
    public func requiredValidation(message: String? = nil) -> ValidationPublisher {
        self.flatMap({ (value) -> ValidationPublisher in
            InputValidationSchema(value: value)
                .string()
                .required()
                .validate()
        })
            .dropFirst()
            .eraseToAnyPublisher()
    }
}
