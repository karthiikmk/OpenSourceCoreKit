//
//  Created by Karthik on 24/04/22.
//

import Foundation

public enum PlaceHolderType: String {
    case empty
    case error
    
    public var icon: String {
        switch self {
        case .empty: 
            return "scribble.variable"
        case .error:
            return "xmark.circle.fill"
        }
    }
    
    public var message: (title: String, desc: String) {
        switch self {
        case .empty: 
            return ("Sounds empty!", "")   
        case .error: 
            return ("Failed to load!", "Please try again after sometime!")
        }        
    }
}
