//
//  Created by Karthik on 23/11/21.
//

import Foundation

extension URLRequest {

    private var isGetMethod: Bool {
        return self.httpMethod == HTTPMethod.get.rawValue
    }

    mutating
    func setAccessToken(_ token: String) {
        self.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }

    mutating
    func addBody(params: Any?) {
        guard let params = params, !isGetMethod else { return }
        let data = try? JSONSerialization.data(withJSONObject: params, options: [.fragmentsAllowed])
        self.httpBody = data
    }

    mutating
    func set(_ httpMethod: HTTPMethod) {
        self.httpMethod = httpMethod.rawValue
    }

    mutating
    func addUrlBody(params: Any?) {
        guard let params = params as? [String: Any], !isGetMethod else { return }
        let data = params
            .map {"\($0)=\($1)"}
            .joined(separator: "&")
            .data(using: String.Encoding.utf8)
        self.httpBody = data
    }
    
    mutating 
    func encodesParamsInUrl(params: Any?) {
        guard let params = params,
              let paramDict = params as? [String: Any],
              !paramDict.isEmpty,
              let url = self.url else {
            return
        }
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let encodingString = QueryStringEncoding().query(paramDict)
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + encodingString
            urlComponents.percentEncodedQuery = percentEncodedQuery
            self.url = urlComponents.url
        }
    }

    mutating
    func setContentType(_ type: RequestContentType) {
        self.setValue(type.contentType, forHTTPHeaderField: "Content-Type")
    }

    mutating
    func addArrayParamIfNeeded(_ arrayParams: [Any]? = nil) {
        guard let params = arrayParams, !isGetMethod else { return }
        let data = try? JSONSerialization.data(withJSONObject: params, options: [.fragmentsAllowed])
        self.httpBody = data
    }
	
	mutating
	func add(_ httpHeaderFields: [String: String?]) {
		httpHeaderFields.forEach { self.setValue($0.value, forHTTPHeaderField: $0.key)}
	}
}

extension URL {
    func addQueryParamIfNeeded(_ queryParams: [String: Any]?) -> URL {
        guard let queryParams = queryParams,
              var urlComponents = URLComponents(string: absoluteString) else {
                  return absoluteURL
              }
        let queryItems = queryParams.map { URLQueryItem(name: $0, value: "\($1)") }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
}

extension NSNumber {
    var isBool: Bool {
        // Use Obj-C type encoding to check whether the underlying type is a `Bool`, as it's guaranteed as part of
        // swift-corelibs-foundation, per [this discussion on the Swift forums](https://forums.swift.org/t/alamofire-on-linux-possible-but-not-release-ready/34553/22).
        String(cString: objCType) == "c"
    }
}

extension CharacterSet {
    /// Creates a CharacterSet from RFC 3986 allowed characters.
    ///
    /// RFC 3986 states that the following characters are "reserved" characters.
    ///
    /// - General Delimiters: ":", "#", "[", "]", "@", "?", "/"
    /// - Sub-Delimiters: "!", "$", "&", "'", "(", ")", "*", "+", ",", ";", "="
    ///
    /// In RFC 3986 - Section 3.4, it states that the "?" and "/" characters should not be escaped to allow
    /// query strings to include a URL. Therefore, all "reserved" characters with the exception of "?" and "/"
    /// should be percent-escaped in the query string.
    public static let afURLQueryAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        let encodableDelimiters = CharacterSet(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        return CharacterSet.urlQueryAllowed.subtracting(encodableDelimiters)
    }()
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension URLSession {
    
    @available(iOS, deprecated: 15, message: "Use `data(from:delegate:)` instead")
    func data(with url: URL) async throws -> (Data, HTTPURLResponse) {
        try await data(with: URLRequest(url: url))
    }
    
    @available(iOS, deprecated: 15, message: "Use `data(for:delegate:)` instead")
    func data(with request: URLRequest) async throws -> (Data, HTTPURLResponse) {
        let sessionTask = SessionTask()
        
        return try await withTaskCancellationHandler(handler: {
            Task { await sessionTask.cancel() }
        }, operation: { 
            try await withCheckedThrowingContinuation { continuation in
                Task {  
                    await sessionTask.start(request, on: self) { data, response, error in                        
                        guard let data = data, let response = response as? HTTPURLResponse else {
                            continuation.resume(throwing: error ?? URLError(.badServerResponse))
                            return
                        }                        
                        guard (200...299).contains(response.statusCode) else {
                            let error = APIError(statusCode: response.statusCode)
                            Logger.error(error)
                            continuation.resume(throwing: error)                            
                            return
                        }                        
                        continuation.resume(returning: (data, response))
                    }
                }
            }
        })
    }
    
    private actor SessionTask {
        weak var task: URLSessionTask?
        
        func start(_ request: URLRequest, on session: URLSession, completion: @Sendable @escaping (Data?, URLResponse?, Error?) -> Void) {
            let task = session.dataTask(with: request, completionHandler: completion)
            task.resume()
            self.task = task
        }
        
        func cancel() {
            task?.cancel()
        }
    }
}
