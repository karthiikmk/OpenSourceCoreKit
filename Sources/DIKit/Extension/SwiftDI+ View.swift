//
//  Created by Karthik on 19/03/22.
//

import Foundation
import Swinject
import SwinjectAutoregistration
import SwiftUI

public extension View {
    
    /// Set dependency container to view
    func inject(container: Container) -> some View {
        self.environment(\.container, container)
    }
    
    // Inject property into container
    func environmentInject<Value>(_ value: Value) -> some View {
        return self.transformEnvironment(\.container) { con in
            con.autoregister(Value.self) { value }
        }
    }
}
