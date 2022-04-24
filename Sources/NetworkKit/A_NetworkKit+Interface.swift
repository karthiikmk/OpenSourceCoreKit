//
//  Created by Karthik on 02/08/21.
//

import Foundation
import SerializationKit
import TaskKit

/// Cancels the represented request.
public protocol Cancellable {    
    func cancel()
}

extension URLSessionDataTask: Cancellable { }

public protocol NetworkKitInterface: TokenInterceptable {
    associatedtype RequestType: NetworkRequestable

    @discardableResult
	func requestData(
		_ request: RequestType,
        onCompletion: @escaping TaskResultAction<Data>
	) -> Cancellable

    @discardableResult
    func requestCodableData<Decoder>(
        _ request: RequestType,
        decoder: Decoder,
        onCompletion: @escaping TaskResultAction<Decoder.Object>
    ) -> Cancellable where Decoder: CanDecode

    @discardableResult
    func requestJson(
        _ request: RequestType,
        onCompletion: @escaping TaskResultAction<[String: Any]>
    ) -> Cancellable
}

@available(iOS, introduced: 0.1.11, message: "NetworkRequestInterface has been renamed to *NetworkRequestable*")
public protocol NetworkRequestable {
    var url: URL { get }
	var path: String { get }
    var httpMethod: HTTPMethod { get }
	var queryParameter: [String: Any]? { get }
	var parameters: Any? { get }
    var arrayParameters: [Any]? { get }
    var encoding: RequestContentType { get }
    var authorizationType: AuthorizationType { get }
	var httpHeaderFields: [String: String?] { get }
}

public extension NetworkRequestable {
    
    // Making it as optinals
    var arrayParameters: [Any]? { nil }
    var encoding: RequestContentType { .json }
    var authorizationType: AuthorizationType { .bearer }
	var httpHeaderFields: [String: String?] { [:] }
    
    internal func addAccesstokenIfNeeded(
        tokenClosure: @escaping () -> String?
    ) -> URLRequest {
        var request = self.urlRequest
        switch self.authorizationType {
        case .none:
            return request
            
        case .basic, .bearer:
            guard let accesstoken = tokenClosure() else { fatalError("\(request) needs an accesstoken, but callback found nil.") }
            let value = self.authorizationType.value!
            let authValue = value + " " + accesstoken
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
            return request
            
        case .custom(let value, let accesstoken): 
            let authValue = value + " " + accesstoken
            request.addValue(authValue, forHTTPHeaderField: "Authorization")
            return request
        }
    }

    internal var urlRequest: URLRequest {
        var mutableUrl = self.url.appendingPathComponent(path)
        mutableUrl = mutableUrl.addQueryParamIfNeeded(queryParameter)
        var request = URLRequest(url: mutableUrl)
		request.set(httpMethod)
		request.add(httpHeaderFields)
        switch encoding {
        case .json:
            request.setContentType(.json)
            request.addBody(params: parameters)
            request.addArrayParamIfNeeded(arrayParameters)
        case .url:
            request.setContentType(.url)
            request.addUrlBody(params: parameters)
        case .queryString:
            request.setContentType(.queryString)
            request.encodesParamsInUrl(params: parameters)
        }
        return request
    }
}
