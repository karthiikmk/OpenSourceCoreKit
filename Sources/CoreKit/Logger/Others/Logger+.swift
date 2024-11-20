//
//  Created by Karthik on 09/12/21.
//

import Foundation

extension Int64 {
    @available(iOS 15.0, *)
    public func printReadableDate() -> String {
        let date = Date(timeIntervalSince1970: Double(self) / 1000)
        return date.formatted(date: .abbreviated, time: .standard)
    }
}
