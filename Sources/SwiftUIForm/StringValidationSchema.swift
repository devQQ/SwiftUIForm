//
//  StringValidationSchema.swift
//  
//
//  Created by Q Trang on 8/1/20.
//

import Foundation
import Combine

public class StringValidationSchema: ValidationSchema {
    public var value: String
    public var publishers: [ValidationPublisher] = []
    
    public init(value: String, publishers: [ValidationPublisher]) {
        self.value = value
        self.publishers = publishers
    }
    
    public func clone() -> StringValidationSchema {
        StringValidationSchema(value: value, publishers: publishers)
    }
    
    public func custom(fn: (_ value: String) -> ValidationResult) -> StringValidationSchema {
        let publisher = transform(value, mapFn: { val in
            return fn(value)
        })
        publishers.append(publisher)
        
        return clone()
    }
    
    public func email(_ message: String? = nil) -> StringValidationSchema {
        matches(NSRegularExpression.email, value: self.value.lowercased(), message: message)
    }
    
    public func matches(_ pattern: String, value: String? = nil, message: String? = nil) -> StringValidationSchema {
        let testString = value != nil ? value! : self.value
        let errorMessage = message != nil ? message! : StringValidationSchema.Message.matches
        let range = NSMakeRange(0, testString.utf16.count)
        
        let publisher = transform(testString, mapFn: { val in
            do {
                let regex = try NSRegularExpression(pattern: pattern, options: [])
                return regex.firstMatch(in: testString, options: [], range: range) != nil ? .success : .failure(errorMessage)
            } catch {
                return .failure(errorMessage)
            }
        })
        publishers.append(publisher)
        
        return clone()
    }
    
    public func max(_ count: Int, message: String? = nil) -> StringValidationSchema {
        let error = message != nil ? message! : StringValidationSchema.Message.max(count: count)
        let publisher = transform(value, mapFn: { val in
            return String(describing: val).count <= count ? .success : .failure(error)
        })
        publishers.append(publisher)
        
        return clone()
    }
    
    public func min(_ count: Int, message: String? = nil) -> StringValidationSchema {
        let error = message != nil ? message! : StringValidationSchema.Message.min(count: count)
        let publisher = transform(value, mapFn: { val in
            return String(describing: val).count >= count ? .success : .failure(error)
        })
        publishers.append(publisher)
        
        return clone()
    }
    
    public func required(_ message: String? = nil) -> StringValidationSchema {
        let error = message != nil ? message! : StringValidationSchema.Message.required
        let publisher = transform(value, mapFn: { val in
            return !String(describing: val).isEmpty ? .success : .failure(error)
        })
        publishers.append(publisher)
        
        return clone()
    }
}

extension StringValidationSchema {
    public struct Message {
        public static var email: String {
            "Field must contain a valid email"
        }
        
        public static func min(count: Int) -> String {
            "String requires a minimum of \(count) characters"
        }
        
        public static func max(count: Int) -> String {
            "String can not greater than \(count) characters"
        }
        
        public static var matches: String {
            "String does not match regex"
        }
        
        public static var required: String {
            "Field is required"
        }
    }
}

