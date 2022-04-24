//
//  Created by Karthik on 02/08/21.
//

import Foundation
import SerializationKit
import TaskKit

public protocol AccessTokenInterceptor: AnyObject {
    var accessToken: String { get }
}

public protocol TokenInterceptable: AnyObject {
    var tokenInterceptor: AccessTokenInterceptor? { get set }
}

public class NetworkKit<Request: NetworkRequestable>: NetworkKitInterface {

	var session: URLSession
    public weak var tokenInterceptor: AccessTokenInterceptor?
    
    public init(with session: URLSession = .shared) {
		self.session = session
	}

	/// This is to retrive raw Data from the api
	/// - Parameters:
	///   - request: request that confirms URLRequestConvertable
	///   - onCompletion: onCompletion, returns either Data or Error
    ///
    @discardableResult
    public func requestData(
		_ request: Request,
		onCompletion: @escaping TaskResultAction<Data>
	) -> Cancellable {
        let decoder = DataDecoder<Data>()
        return processRequest(request, decoder, onCompletion)
	}

    public func requestData(
        _ request: Request,
        queue: TaskQueue = .default,
        onCompletion: @escaping TaskResultAction<Data>
    ) {
        let decoder = DataDecoder<Data>()
        let task = Task { self.processRequest(request, decoder, $0) }
        task.perform(on: queue.performQueue, handleOn: queue.handleQueue, then: onCompletion)
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
		decoder: Decoder,
        onCompletion: @escaping TaskResultAction<Decoder.Object>
	) -> Cancellable where Decoder: CanDecode {
        return processRequest(request, decoder, onCompletion)
	}

    public func requestCodable<Decoder>(
        _ request: Request,
        decoder: Decoder,
        queue: TaskQueue = .default,
        onCompletion: @escaping TaskResultAction<Decoder.Object>
    ) where Decoder: CanDecode {
        let task = Task { self.processRequest(request, decoder, $0) }
        task.perform(on: queue.performQueue, handleOn: queue.handleQueue, then: onCompletion)
    }

	/// This is to retrive serialized response in the form of Dictionary from the api
	/// - Parameters:
	///   - request: request that confirms URLRequestConvertable
	///   - onCompletion: onCompletion, returns either Dict[String: Error] or Error
    @discardableResult
	public func requestJson(
		_ request: Request,
        onCompletion: @escaping TaskResultAction<[String: Any]>
	) -> Cancellable {        
        let decoder = JsonDecoder<[String: Any]>()
        return processRequest(request, decoder, onCompletion)
	}

    public func requestJson(
        _ request: Request,
        queue: TaskQueue = .default,
        onCompletion: @escaping TaskResultAction<[String: Any]>
    ) {
        let decoder = JsonDecoder<[String: Any]>()
        let task = Task { self.processRequest(request, decoder, $0) }
        task.perform(on: queue.performQueue, handleOn: queue.handleQueue, then: onCompletion)
    }
}

// MARK: Network Process
extension NetworkKit {

    @discardableResult
    fileprivate func processRequest<Decoder>(
        _ request: NetworkRequestable,
        _ decoder: Decoder,
        _ onCompletion: @escaping TaskResultAction<Decoder.Object>
    ) -> URLSessionDataTask where Decoder: CanDecode {

        // Adding Auth
        let request = request.addAccesstokenIfNeeded { return self.tokenInterceptor?.accessToken }

        // Anything else can be added here [Like Moya plugins]
        Logger.debug("Network request on: \(Thread.isMainThread ? "Main" : "Backgroud")Thread - \(String(describing: request.url?.absoluteString))")
        Logger.log(request)

        let task: URLSessionDataTask = session.dataTask(with: request) { (responseData, response, error) -> Void in
            if let error = error {
                onCompletion(.failure(error))
                return
            }
            guard let data = responseData else {
                onCompletion(.failure(NetworkError.noData))
                return
            }
            guard let response = response as? HTTPURLResponse else {
                onCompletion(.failure(NetworkError.noData))
                return
            }            
            guard (200...299).contains(response.statusCode) else {
                let error = APIError(statusCode: response.statusCode)
                Logger.error(error)
                onCompletion(.failure(error))
                return
            }
            onCompletion(decoder.decode(data))
        }
        task.resume()
        return task
    }
}
