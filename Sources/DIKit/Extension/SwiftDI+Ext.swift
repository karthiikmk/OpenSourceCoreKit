//
//  Created by Karthik on 24/04/22.
//

import Foundation
import Swinject

extension Container {
    func resolve<Dependency>() -> Dependency {
        return resolve(Dependency.self)!
    }
}

extension Resolver {
    func resolve<Dependency>() -> Dependency {
        return resolve(Dependency.self)!
    }
}
