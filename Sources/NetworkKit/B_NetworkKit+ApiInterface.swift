//
//  Created by Karthik on 28/12/21.
//

import Foundation
import SerializationKit
import TaskKit

public protocol BaseApiInterface {
    associatedtype RequestType: NetworkRequestable

    var networkKit: NetworkKit<RequestType> { get }
    var apiConfig: ApiConfigInterface { get }
    var tokenInterceptor: AccessTokenInterceptor? { get set }

    init(networkKit: NetworkKit<RequestType>?, apiConfig: ApiConfigInterface)
    
    @discardableResult
    func requestData(_ request: RequestType, onCompletion: @escaping TaskResultAction<Data>) -> Cancellable
        
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    func requestData(_ request: RequestType) async throws -> Data
    
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    func requestCodable<Decoder>(_ request: RequestType, decoder: Decoder) async throws -> Decoder.Object where Decoder: CanDecode
    
    @available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
    func requestJson(_ request: RequestType) async throws -> [String: Any]
}

public protocol ApiConfigInterface {
    var environment: NetworkModel.ApiEnvironment { get }
    init(environment: NetworkModel.ApiEnvironment)
}

public class BaseApiConfig: ApiConfigInterface {
    public var environment: NetworkModel.ApiEnvironment
    
    required public init(environment: NetworkModel.ApiEnvironment) {
        self.environment = environment
    }
}

extension BaseApiInterface {

    @discardableResult
    public func requestData(
        _ request: RequestType,
        onCompletion: @escaping TaskResultAction<Data>
    ) -> Cancellable {
        return networkKit.requestData(request, onCompletion: onCompletion)
    }

    @discardableResult
    public func requestCodable<Decoder>(
        _ request: RequestType,
        decoder: Decoder,
        onCompletion: @escaping TaskResultAction<Decoder.Object>
    ) -> Cancellable where Decoder: CanDecode {
        return networkKit.requestCodableData(request, decoder: decoder, onCompletion: onCompletion)
    }

    @discardableResult
    public func requestJson(
        _ request: RequestType,
        onCompletion: @escaping TaskResultAction<[String: Any]>
    ) -> Cancellable {
        return networkKit.requestJson(request, onCompletion: onCompletion)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension BaseApiInterface {
            
    public func requestData(_ request: RequestType) async throws -> Data {
        return try await networkKit.requestData(request)
    }

    public func requestCodable<Decoder>(
        _ request: RequestType,
        decoder: Decoder
    ) async throws -> Decoder.Object where Decoder: CanDecode {
        return try await networkKit.requestCodableData(request, decoder: decoder)
    }
    
    public func requestJson(_ request: RequestType) async throws -> [String: Any] {
        return try await networkKit.requestJson(request)
    }
}
