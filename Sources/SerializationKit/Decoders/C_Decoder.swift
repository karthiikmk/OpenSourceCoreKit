//
//  Created by Karthik on 07/08/21.
//

import Foundation
import Result

// MARK: - Decode
public protocol CanDecode {
    associatedtype Object

    func decode(_ data: Data) -> Result<Object, Error>
    func optionalDecode(_ data: Data) -> Object?
    func throwableDecode(_ data: Data) throws -> Object
}

// MARK: - EmptyDecoder
public struct EmptyDecoder {
    public init() { }
}

extension EmptyDecoder: CanDecode {

    public func decode(_ data: Data) -> Result<Void, Error> {
        return .success(())
    }

    public func optionalDecode(_ data: Data) -> Void? {
        return (())
    }

    public func throwableDecode(_ data: Data) throws -> Void {
        return (())
    }
}

// MARK: Data
// This does nothing, helps in grouping the network response into a single place
public struct DataDecoder<D> {
    public init() { }
}

extension DataDecoder: CanDecode {
    public typealias Object = Data

    public func decode(_ data: Data) -> Result<Data, Error> {
        return .success(data)
    }

    public func optionalDecode(_ data: Data) -> Data? {
        return data
    }

    public func throwableDecode(_ data: Data) throws -> Data {
        return data
    }
}

// MARK: - JSON
public struct JsonDecoder<JSON> {
    public init() { }
}

extension JsonDecoder: CanDecode {

    public func throwableDecode(_ data: Data) throws -> JSON {
        do {
            let json = try JSONSerialization.jsonObject(with: data)
            return json as! JSON
        } catch DecodingError.keyNotFound(let key, let context) {
            let error = "couldn't find key -> (\(key)), in JSON \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch DecodingError.valueNotFound(let type, let context) {
            let error = "couldn't find value for type(\(type)), in JSON \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch DecodingError.typeMismatch(let type, let context) {
            let error = "decoding type missmatch for type(\(type)), in JSON \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        }catch {
            Logger.error(error)
            throw error
        }
    }

    public func decode(_ data: Data) -> Result<JSON, Error> {
		do {
            let json = try throwableDecode(data)
            return .success(json)
		} catch {
            return .failure(error)
		}
	}

    public func optionalDecode(_ data: Data) -> JSON? {
        switch decode(data) {
        case .failure:
            return nil
        case .success(let json):
            return json
        }
    }
}

// MARK: - Codable
public struct CodableDecoder<Model> where Model: Decodable {
    let decoder: JSONDecoder
    public init(decoder: JSONDecoder = .init(dateDecodingStrategy: .formatted(.serverDateFormatter))) {
        self.decoder = decoder
    }
}

extension CodableDecoder: CanDecode {

    public func throwableDecode(_ data: Data) throws -> Model {
        do {
            return try decoder.decode(Model.self, from: data)
        } catch DecodingError.keyNotFound(let key, let context) {
            let error = "couldn't find key -> (\(key)), in JSON \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch DecodingError.valueNotFound(let type, let context) {
            let error = "couldn't find value for type(\(type)), in JSON \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch DecodingError.typeMismatch(let type, let context) {
            let error = "decoding type missmatch for type(\(type)), in JSON \(context.debugDescription)"
            Logger.error(error)
            throw SerializationError(error)
        } catch {
            Logger.error(error)
            throw error
        }
    }

    public func decode(_ data: Data) -> Result<Model, Error> {
        do {
            let model = try throwableDecode(data)
            return .success(model)
        } catch {
            return .failure(error)
        }
    }

    public func optionalDecode(_ data: Data) -> Model? {
        switch decode(data) {
        case .failure:
            return nil
        case .success(let model):
            return model
        }
    }
}
