import Foundation

public struct LoggerKit { }

public extension LoggerKit {

    struct Log: CustomStringConvertible {

        public let payload: Payload
        public let data: String?
        public let severity: Severity
        public let file: String
        public let function: String
        public let line: Int
        public let timestamp: Date

        public var message: String? {
            switch payload {
            case let .message(message):
                return message
            default:
                return nil
            }
        }

        public var description: String {
            guard let newdata = data else {
                return payload.description
            }
            return "\(newdata) \(payload.description)"
        }

        public init(
            payload: Payload,
            data: String? = nil,
            severity: LoggerKit.Severity,
            file: String,
            function: String,
            line: Int,
            timestamp: Date = Date()
        ) {
            self.payload = payload
            self.data = data
            self.severity = severity
            self.file = file
            self.function = function
            self.line = line
            self.timestamp = timestamp
        }

        func append(data newdata: String?) -> Log {
            guard let newdata = newdata?.trimmingCharacters(in: .whitespacesAndNewlines) else { return self }
            guard !newdata.isEmpty else { return self }

            let new: String
            if let old = data, !old.isEmpty {
                new = "\(old) \(newdata)"
            } else {
                new = newdata
            }
            return Log(
                payload: payload,
                data: new,
                severity: severity,
                file: file,
                function: function,
                line: line,
                timestamp: timestamp
            )
        }
    }
}

extension LoggerKit.Log {

    public enum Payload: CustomStringConvertible {
        case trace
        case message(String)
        case error(Error)
        case value(Any?)

        public var description: String {
            switch self {
            case .trace:
                return ""
            case .message(let text):
                return text
            case .error(let error):
                return "\(error)"
            case .value(let value):
                if let value = value { return "\(value)" }
                return "<nil-value>"
            }
        }
    }
}
