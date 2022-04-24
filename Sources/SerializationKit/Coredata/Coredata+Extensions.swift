//
//  Created by Karthik on 01/01/22.
//

import UIKit
import CoreData

internal extension NSManagedObjectContext {
    func performAndWait<T>(_ block: () throws -> T) throws -> T {
        var result: Result<T, Error>?
        performAndWait {
            result = Result { try block() }
        }
        return try result!.get()
    }
}

extension CodingUserInfoKey {
    public static let context = CodingUserInfoKey(rawValue: "ManagedObjectContext_CodingKey")!
    public static let type = CodingUserInfoKey(rawValue: "ManagedObjectType_CodingKey")!
    public static let accountId = CodingUserInfoKey(rawValue: "ManagedObjectAccountId_CodingKey")!
    public static let userId = CodingUserInfoKey(rawValue: "UserId_CodingKey")!
    public static let contactResponseData = CodingUserInfoKey(rawValue: "ContactData_CodingKey")!
}

public extension NSManagedObject {

    internal static var nameOfClass: String {
        return String(describing: Self.self)
    }

    convenience init(baseObject decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext,
              let entity = NSEntityDescription.entity(
                forEntityName: Self.nameOfClass,
                in: context
              ) else { fatalError() }
        self.init(entity: entity, insertInto: context)
    }
}

public extension JSONDecoder {

    convenience init(context: NSManagedObjectContext) {
        self.init()
        self.userInfo[.context] = context
    }
    
    convenience init(context: NSManagedObjectContext, type: String) {
        self.init()
        self.userInfo[.context] = context
        self.userInfo[.type] = type
    }

    convenience init(userId: String) {
        self.init()
        self.userInfo[.userId] = userId
    }
}

public extension JSONDecoder {
    
    // MARK: - Decode & Save
    func syncSaveList<T: Decodable>(
        _ type: T.Type,
        from jsonData: Data,
        resultHandler: (([T]) -> Void)? = nil
    ) throws {
        guard let _context = self.userInfo[.context] as? NSManagedObjectContext else {
            throw SerializationError("context not found")
        }
        try _context.performAndWait {
            guard let objects = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as? [[String: AnyObject]] else {
                throw SerializationError("unable to serialize json data \(jsonData)")
            }
            var list: [T] = []
            for object in objects {
                let serializedData = try JSONSerialization.data(withJSONObject: object, options: .fragmentsAllowed)
                let object = try self.decode(T.self, from: serializedData)
                list.append(object)
            }
            try _context.save()
            resultHandler?(list)
        }
    }
}

extension Int64 {
    init(string: String?) throws {
        guard let string = string, let value = Int64(string) else { 
            throw SerializationError("Serialization Error", description: "Unable to convert string to Int64")            
        }
        self = value
    }
}
