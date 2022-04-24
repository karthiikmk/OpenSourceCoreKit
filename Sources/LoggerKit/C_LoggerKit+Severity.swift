//
//  Created by Karthik on 09/12/21.
//

import Foundation

public extension LoggerKit {

    enum Severity: Int, Comparable, CustomStringConvertible {

        public static func < (lhs: Severity, rhs: Severity) -> Bool {
            return lhs.rawValue < rhs.rawValue
        }

        case verbose = 0
        case debug
        case info
        case warning
        case error

        public var description: String {
            switch self {
            case .verbose:
                return "🖤🖤"
            case .debug:
                return "💙💙"
            case .info:
                return "💚💚"
            case .warning:
                return "🧡🧡"
            case .error:
                return "❤️❤️"
            }
        }
    }
}
