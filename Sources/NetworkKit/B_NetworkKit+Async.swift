//
//  Created by Karthik on 21/04/22.
//

import Foundation
import SerializationKit

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension NetworkKit {
    
    @discardableResult
    public func requestData(_ request: Request) async throws -> Data {
        let decoder = DataDecoder<Data>()
        return try await processRequest(request, decoder)
    }
    
    /// This is to retrive serialized response in the form of Dictionary from the api
    /// - Parameters:
    ///   - request: request that confirms URLRequestConvertable
    ///   - onCompletion: onCompletion, returns either Dict[String: Error] or Error
    @discardableResult
    public func requestJson(_ request: Request) async throws -> [String: Any] {        
        let decoder = JsonDecoder<[String: Any]>()
        return try await processRequest(request, decoder)
    }
    
    /// This is to retrive the data in a codable form.
    /// - Parameters:
    ///   - request: request that confirms URLRequestConvertable
    ///   - decoder: type of pojo
    ///   - onCompletion: onCompletion it returns eiter pojo or error
    ///
    @discardableResult
    public func requestCodableData<Decoder>(
        _ request: Request,
        decoder: Decoder
    ) async throws -> Decoder.Object where Decoder: CanDecode {
        return try await processRequest(request, decoder)
    }
}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, *)
extension NetworkKit {    
    
    @discardableResult 
    fileprivate func processRequest<Decoder>(
        _ request: NetworkRequestable,
        _ decoder: Decoder
    ) async throws -> Decoder.Object where Decoder: CanDecode {
        
        let request = request.addAccesstokenIfNeeded {
            return self.tokenInterceptor?.accessToken             
        }        
        
        // Anything else can be added here [Like Moya plugins]
        Logger.debug("Network request on: \(Thread.isMainThread ? "Main" : "Backgroud")Thread - \(String(describing: request.url?.absoluteString))")
        Logger.log(request)
        
        let (data, _) = try await session.data(with: request)
        return try decoder.throwableDecode(data)
    }
}
