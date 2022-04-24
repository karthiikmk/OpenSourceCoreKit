//
//  Created by Karthik on 10/02/22.
//

import Foundation

public struct NetworkModel {
    
    public struct ApiConfig: ApiConfigInterface {
        public var environment: ApiEnvironment
        
        public init(environment: ApiEnvironment) {
            self.environment = environment
        }
    }
    
    public enum ApiEnvironment {
        case live
        case staging
        case nonDefault(data: [String: String])
    }
}
