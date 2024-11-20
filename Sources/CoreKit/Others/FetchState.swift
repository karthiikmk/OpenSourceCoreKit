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

public enum ViewState {
    /// The view is currently loading data.
    case loading
    /// The view has loaded data, but the list is empty.
    case empty
    /// The view failed to load data.
    case failed
    /// The view has successfully loaded data.
    case loaded
}
