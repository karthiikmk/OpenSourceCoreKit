//
//  Created by Karthik on 26/08/21.
//

import Foundation
import LoggerKit

public struct SerializationError: Error {
    public let message: String
    public var description: String?

    public init(_ message: String, description: String? = nil) {
        self.message = message
        self.description = description
    }
}

internal typealias Logger = SerializationKit.Logger

extension SerializationKit {

    public struct Logger: LoggerInterface {
        public static var logTag: String { "SerializationKit" }
        public static var logConfig: LoggerKit.Config? = .init(enable: true, severity: .info)
    }
}
