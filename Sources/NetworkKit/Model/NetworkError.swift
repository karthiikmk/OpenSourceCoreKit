//
//  Created by Karthik on 23/11/21.
//

import Foundation

public enum NetworkError: Error {
    case success
    case authError
    case badRequest
    case outdated
    case failed
    case noData
    case undefined
    case unableToDecode(_ error: Error)
	case failedWithData(_ data: Data)
}

struct APIError: Error {
    let statusCode: Int
    var errorDescription: NetworkError {
        switch statusCode {
        case 401...500: return .authError
        case 501...599: return .badRequest
        case 600: return .outdated
        default: return .undefined
        }
    }
}

public enum RequestContentType {
    case json 
    case url 
    case queryString 
    
    var contentType: String {
        switch self {
        case .json, .queryString: return "application/json"
        case .url: return "application/x-www-form-urlencoded"
        }
    }
}
