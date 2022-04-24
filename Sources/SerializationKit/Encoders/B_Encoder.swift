//
//  Created by Karthik on 07/08/21.
//

import Foundation

// MARK: - Encode
public protocol CanEncode {
	associatedtype Object

    func encode(_ object: Object) -> Result<Data, Error>
	func optionalEncode(_ object: Object) -> Data?
    func throwableEncode(_ object: Object) throws -> Data
}

// MARK: - JSON
public struct JsonEncoder<JSON> {
    public init() { }
}

extension JsonEncoder: CanEncode {

    public func throwableEncode(_ object: JSON) throws -> Data {
        do {
            return try JSONSerialization.data(withJSONObject: object)
        } catch EncodingError.invalidValue(let value, let context) {
            let error = "received invalid value on encoding \(value) - \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch {
            Logger.error(error)
            throw error
        }
    }

    public func optionalEncode(_ object: JSON) -> Data? {
        do { return try throwableEncode(object)
        } catch { return nil }
    }

    public func encode(_ object: JSON) -> Result<Data, Error> {
        do {
            let data = try throwableEncode(object)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - Codable
public struct CodableEncoder<Model>: CanEncode where Model: Encodable {
    let encoder: JSONEncoder
    public init(encoder: JSONEncoder = .init(dateEncodingStrategy: .formatted(.serverDateFormatter))) {
        self.encoder = encoder
    }
}

public extension CodableEncoder {

    func throwableEncode(_ object: Model) throws -> Data {
        do {
            return try encoder.encode(object)
        } catch EncodingError.invalidValue(let value, let context) {
            let error = "received invalid value on encoding \(value) - \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch {
            throw error
        }
    }

    func optionalEncode(_ object: Model) -> Data? {
        do { return try throwableEncode(object)
        } catch { return nil }
    }

    func encode(_ object: Model) -> Result<Data, Error> {
        do {
            let data = try throwableEncode(object)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
}
