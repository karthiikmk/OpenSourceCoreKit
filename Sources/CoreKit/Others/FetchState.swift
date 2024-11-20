//
//  Created by Karthik on 24/04/22.
//

import Foundation

public enum FetchState {
    case idle
    case fetching
    case error
    case completed
    
    public var isFetching: Bool {
        self == .fetching
    }
}
