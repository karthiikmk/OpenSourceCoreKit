//
//  Created by Karthik on 06/04/22.
//

import Foundation
import Swinject
import SwiftUI

// Containers
// Assemblers(Groups)  

// Assemblers users containers to resolve the objects
// Assemblers holds container to resolve the objects

/* 💙💙 Note: Hierarcy
 - Service
 - ViewModel
 */ 
public class SwiftDI: SwiftDIInterface {
    public static let shared = SwiftDI()
    
    // Holding for later register & resolving. 
    public var container: Container!
    public var assembler: Assembler!
    public var resolver: Resolver { assembler.resolver }
    
    public func setup(assemblies: [Assembly], inContainer container: Container) {
        self.container = container
        self.assembler = Assembler(assemblies, container: container)
    }
}
