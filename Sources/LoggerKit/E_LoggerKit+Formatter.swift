//
//  Created by Karthik on 09/12/21.
//

import Foundation

public extension LoggerKit {

    struct Formatters {

        public static func defaultFormatter(_ logTag: String) -> LogFormatter {
            return LoggerKit.Formatters.Concatenating([
                SeverityFormatter(),
                LogTagFormatter(logTag),
                PrefixFormatter(),
            ])
        }
    }
}

// Helps to construct string like adding file, name, sererity etc
public extension LoggerKit.Formatters {

    class Concatenating: LogFormatter {

        public let formatters: [LogFormatter]

        public init(_ formatters: [LogFormatter]) {
            self.formatters = formatters
        }

        public func format(entry: LoggerKit.Log) -> LoggerKit.Log {
            return formatters.reduce(entry) { $1.format(entry: $0) }
        }
    }

    class LogTagFormatter: LogFormatter {

        public let logTag: String
        public init(_ logTag: String) {
            self.logTag = logTag
        }
        public func format(entry: LoggerKit.Log) -> LoggerKit.Log {
            return entry.append(data: "[\(logTag)]: ")
        }
    }

    class PrefixFormatter: LogFormatter {
        public func format(entry: LoggerKit.Log) -> LoggerKit.Log {
            let filename = (entry.file as NSString).pathComponents.last ?? "redacted"
            return entry.append(data: "\(filename): \(entry.line) - ")
        }
    }

    class SeverityFormatter: LogFormatter {
        public func format(entry: LoggerKit.Log) -> LoggerKit.Log {
            return entry.append(data: entry.severity.description)
        }
    }

    class StaticStringFormatter: LogFormatter {
        public let text: String
        public init(_ text: String) {
            self.text = text
        }
        public func format(entry: LoggerKit.Log) -> LoggerKit.Log {
            return entry.append(data: text)
        }
    }
}
