//
//  Created by Karthik on 20/03/22.
//

import Foundation
import Swinject

@propertyWrapper
public struct Inject<Service> {
    private var service: Service
    
    public init() {
        let resolver = Self.getResolver()        
        guard let service = resolver.resolve(Service.self) else {
            fatalError("Service of type \(Service.self) not found. You can try `OptionalInjected` instead.")
        }
        self.service = service
    }
    
    public init(name: String?) {
        let resolver = Self.getResolver()
        guard let service = resolver.resolve(Service.self, name: name) else {
            fatalError("Service of type \(Service.self) not found. You can try `OptionalInjected` instead.")
        }        
        self.service = service
    }
    
    public init<Arg1>(argument arg1: Arg1) {
        let resolver = Self.getResolver()
        guard let service = resolver.resolve(Service.self, argument: arg1) else {
            fatalError("Service of type \(Service.self) not found. You can try `OptionalInjected` instead.")
        }        
        self.service = service
    }
    
    public init<Arg1>(name: String?, argument arg1: Arg1) {
        let resolver = Self.getResolver()        
        guard let service = resolver.resolve(Service.self, name: name, argument: arg1) else {
            fatalError("Service of type \(Service.self) not found. You can try `OptionalInjected` instead.")
        }        
        self.service = service
    }
    
    private static func getResolver() -> Resolver {
        return SwiftDI.shared.resolver
    }
    
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public var projectedValue: Inject<Service> {
        get { return self }
        mutating set { self = newValue }
    }
}
