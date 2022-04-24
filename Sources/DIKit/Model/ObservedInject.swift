//
//  Created by Karthik on 06/04/22.
//

import Foundation
import SwiftUI
import Combine

/// A dynamic view property that subscribes to a `ObservableObject` automatically invalidating the view
/// when it changes.
/// 
/// You see, right now SwiftUI doesn’t realize it should be watching our property wrapper for change notification,
/// even though it has an @State/@ObservedObject property inside there. 
/// To fix this we need to conform to the DynamicProperty protocol, like this:
@propertyWrapper
public struct ObservedInject<Value: ObservableObject>: DynamicProperty {
    
    @ObservedObject private var _wrappedValue: Value
    public var wrappedValue: Value {
        _wrappedValue
    }
    
    public init() {
        guard let resolvedValue = Environment(\.container).wrappedValue.resolve(Value.self) else { 
            fatalError("Couldn't found object for type \(Value.self)")
        }
        self.__wrappedValue = ObservedObject<Value>(initialValue: resolvedValue)
    }
    
    /// The binding value, as "unwrapped" by accessing `$foo` on a `@Binding` property.
    public var projectedValue: ObservedObject<Value>.Wrapper {
        return __wrappedValue.projectedValue
    }
}
