//
//  Created by Karthik on 19/03/22.
//

import Foundation
import Swinject
import SwiftUI

struct DIContainerEnvironmentKey: EnvironmentKey {
    static var defaultValue: Container = SwiftDI.shared.container
}

extension EnvironmentValues {
    var container: Container {
        get { self[DIContainerEnvironmentKey.self] }
        set { self[DIContainerEnvironmentKey.self] = newValue }
    }
}
