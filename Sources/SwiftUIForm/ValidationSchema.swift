//
//  ValidationSchema.swift
//  
//
//  Created by Q Trang on 8/1/20.
//

import Foundation
import Combine
import SwiftUIToolbox

public enum InputState {
    case editing
    case entry
    case error
}

public enum ValidationResult {
    case success
    case failure(String)
    
    public var isSuccess: Bool {
        if case .success = self {
            return true
        }
        
        return false
    }
}

public typealias ValidationPublisher = AnyPublisher<ValidationResult, Never>

public protocol ValidationSchema {
    associatedtype ValueType
    
    var value: ValueType { get set }
    var publishers: [ValidationPublisher] { get set }
}

extension ValidationSchema {
    public func transform(_ value: Any, mapFn: (Any) -> ValidationResult) -> ValidationPublisher {
        return Just(value).map(mapFn).eraseToAnyPublisher()
    }
    
    public func validate() -> ValidationPublisher {
        let publisher: ValidationPublisher = publishers.combineLatest.map({results in
            
            for result in results {
                if case .failure = result {
                    return result
                }
            }
            
            return .success
        })
            .eraseToAnyPublisher()
        
        return publisher
    }
}
