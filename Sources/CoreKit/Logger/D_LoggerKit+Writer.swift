//
//  Created by Karthik on 09/12/21.
//

import Foundation

public extension LoggerKit {

    struct Writers {
        public static let `default`: LogWriter = {
            return PrintLogWriter()
        }()
    }
}

extension LoggerKit.Writers {

    public class PrintLogWriter: LogWriter {
        public func write(entry: LoggerKit.Log) {
            print(entry)
        }
    }
}
