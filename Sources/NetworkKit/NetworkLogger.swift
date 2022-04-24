//
//  Created by Karthik on 03/08/21.
//

import Foundation
import LoggerKit

typealias Logger = NetworkLogger.Logger

public struct NetworkLogger {

    public struct Logger: LoggerInterface {
		public static var logTag: String = "NetworkKit"
        public static var logConfig: LoggerKit.Config? = .init(enable: false)

        static func log(_ request: URLRequest) {
            guard self.enable, self.severity == .verbose else { return }

            print("\n - - - - - - - - - - - - - - OUTGOING - - - - - - - - - -- - - -")
            defer { print("- - - - - - - - - - - - - -  END - - - - - - - - - - - - - -\n") }

            let urlAsString = request.url?.absoluteString ?? ""
            let urlComponents = NSURLComponents(string: urlAsString)

            let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
            let path = "\(urlComponents?.path ?? "")"
            let query = "\(urlComponents?.query ?? "")"
            let host = "\(urlComponents?.host ?? "")"

            var logOutput = """
                        \(urlAsString) \n\n
                        \(method) \(path)?\(query) HTTP/1.1 \n
                        HOST: \(host)\n
                        """
            for (key,value) in request.allHTTPHeaderFields ?? [:] {
                logOutput += "\(key): \(value) \n"
            }
            if let body = request.httpBody {
                logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
            }

            print(logOutput)
        }

        static func log(response: URLResponse) {}
    }
}
