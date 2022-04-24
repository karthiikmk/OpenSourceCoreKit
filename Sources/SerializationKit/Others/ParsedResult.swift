//
//  Created by Pandian on 25/02/22.
//

import Foundation

public struct ParsedResult<T> {
    public let objects: T
    public let errors: [Error]

    public init(objects: T, errors: [Error]) {
        self.objects = objects
        self.errors = errors
    }
}
