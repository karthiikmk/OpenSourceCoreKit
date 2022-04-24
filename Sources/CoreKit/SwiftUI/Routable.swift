//
//  Created by Karthik on 18/04/22.
//

import Foundation
#if canImport(SwiftUI)
import SwiftUI

public typealias RouteType = Hashable & CaseIterable & Hashable

@available(iOS 13.0, *)
public protocol BaseRouter {
    associatedtype Route: RouteType
    associatedtype Body: View
    
    @ViewBuilder func view(for route: Route) -> Self.Body
}

@available(iOS 13.0, *)
public protocol BaseViewModel: ObservableObject {
    associatedtype Route: RouteType    
    var activeRoute: Route? { get set }
}

@available(iOS 13.0, *)
public protocol BaseView: View {
    associatedtype VM: BaseViewModel
    associatedtype Router: BaseRouter where Router.Route == VM.Route
    
    var viewModel: VM { get }
    var router: Router { get }
}
#endif
