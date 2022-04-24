//
//  Created by Karthik on 14/12/21.
//

import Foundation

public enum AuthorizationType {

    case none
    case basic
    case bearer
    case custom(field: String, accesstoken: String)

    public var value: String? {
        switch self {
        case .none: return nil
        case .basic: return "Basic"
        case .bearer: return "Bearer"
        case .custom(let customValue, _): 
            return customValue
        }
    }

    var canAddAccesstoken: Bool {
        switch self {
        case .none: return false
        default: return true
        }
    }
}
