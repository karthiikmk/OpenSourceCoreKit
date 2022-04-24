//
//  Created by Karthik on 22/01/22.
//

import UIKit

public class TaskQueue {
    public let performQueue: DispatchQueue
    public let handleQueue: DispatchQueue

    public init(performQueue: DispatchQueue, handleQueue: DispatchQueue) {
        self.performQueue = performQueue
        self.handleQueue = handleQueue
    }
}

public extension TaskQueue {

    static let `default` = TaskQueue(
        performQueue: .global(qos: .background),
        handleQueue: .main
    )
    static let syncQueue = TaskQueue(
        performQueue: .main,
        handleQueue: .main
    )
    static let asyncQueue = TaskQueue(
        performQueue: .global(qos: .background),
        handleQueue: .global(qos: .background)
    )
}
