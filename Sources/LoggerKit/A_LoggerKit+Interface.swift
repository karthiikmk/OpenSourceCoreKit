//
//  Created by Karthik on 09/12/21.
//

import Foundation

public protocol LogWriter {
    func write(entry: LoggerKit.Log)
}

public protocol LogFormatter {
    func format(entry: LoggerKit.Log) -> LoggerKit.Log
}

public extension LoggerKit {
    struct Config {
        public let enable: Bool
        public let severity: LoggerKit.Severity

        public init(enable: Bool, severity: LoggerKit.Severity = .info) {
            self.enable = enable
            self.severity = severity
        }
    }
}

// NOTE: LogWriter and LogFormatter is optional since its should set as well.
// WORKAROUND: https://karthikmk.medium.com/the-flaw-swift-protocol-with-computed-properties-4b5b70d2d72b
public protocol LoggerInterface {
    static var logTag: String { get }
    static var logConfig: LoggerKit.Config? { get set }
}

// Internal use only.
extension LoggerInterface {
    internal static var config: LoggerKit.Config {
        get { return self.logConfig ?? .init(enable: true, severity: .info) }
        set { self.logConfig = newValue } // unusable
    }
    public static var enable: Bool { config.enable }
    public static var severity: LoggerKit.Severity { config.severity }
    internal static var writer: LogWriter { LoggerKit.Writers.default }
    internal static var formatter: LogFormatter { LoggerKit.Formatters.defaultFormatter(logTag) }
}

extension LoggerInterface {

    internal static func shouldWrite(severity: LoggerKit.Severity) -> Bool {
        return self.enable && (severity >= self.severity)
    }

    internal static func write(entry: LoggerKit.Log) {
        let formatter = formatter.format(entry: entry)
        writer.write(entry: formatter)
    }

    // Can be used to print just file, func and line alone. kind of deep logs
    public static func trace(_ file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .verbose) else { return }
        let entry: LoggerKit.Log = .init(payload: .trace, severity: .verbose, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func verbose(_ value: Any?, _ file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .verbose) else { return }
        let entry: LoggerKit.Log = .init(payload: .value(value), severity: .verbose, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .debug) else { return }
        let entry: LoggerKit.Log = .init(payload: .message(message), severity: .debug, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func debug(_ value: Any?, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .debug) else { return }
        let entry: LoggerKit.Log = .init(payload: .value(value), severity: .debug, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .info) else { return }
        let entry: LoggerKit.Log = .init(payload: .message(message), severity: .info, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func warning(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .warning) else { return }
        let entry: LoggerKit.Log = .init(payload: .message(message), severity: .warning, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func error(_ error: Error, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .error) else { return }
        let entry: LoggerKit.Log = .init(payload: .error(error), severity: .error, file: file, function: function, line: line)
        write(entry: entry)
    }

    public static func error(_ error: Error?, file: String = #file, function: String = #function, line: Int = #line) {
        if let err = error {
            self.error(err, file: file, function: function, line: line)
        }
    }

    public static func error(_ error: String, file: String = #file, function: String = #function, line: Int = #line) {
        guard shouldWrite(severity: .error) else { return }
        let entry: LoggerKit.Log = .init(payload: .message(error), severity: .error, file: file, function: function, line: line)
        write(entry: entry)
    }
}
