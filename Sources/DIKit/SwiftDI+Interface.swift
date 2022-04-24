//
//  Created by Karthik on 24/04/22.
//

import Foundation
import Swinject

public protocol SwiftDIResolverInterface: AnyObject {
    var assembler: Assembler! { get set }
    
    func resolve<ViewModel>() -> ViewModel
}

public extension SwiftDIResolverInterface {
    func resolve<ViewModel>() -> ViewModel {
        assembler.resolver.resolve()
    }
}

public protocol SwiftDIInterface: SwiftDIResolverInterface {
    var container: Container! { get set }
    var resolver: Resolver { get }
    
    func setup(assemblies: [Assembly], inContainer container: Container)
    func resetObjectScope(_ objectScope: ObjectScope)
}  

public extension SwiftDIInterface {    
    func resetObjectScope(_ objectScope: ObjectScope) {
        container.resetObjectScope(objectScope)
    }
}
