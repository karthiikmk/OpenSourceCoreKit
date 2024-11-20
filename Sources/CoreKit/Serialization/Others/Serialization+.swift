//
//  Created by Karthik on 07/08/21.
//

import Foundation
import Result

private extension DateFormatter {
	convenience init(dateFormat: String) {
		self.init()
		self.dateFormat = dateFormat
	}
}

extension DateFormatter {
	public static let serverDateFormatter: DateFormatter = .init(dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ")
}

public extension JSONEncoder {

	/// - Warning: Although this has `public` access, it is intended for internal use and should not be used directly
	///   by host applications. The behavior of this may change without warning.
	convenience init(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy) {
		self.init()
		self.dateEncodingStrategy = dateEncodingStrategy
	}
}

public extension JSONDecoder {

	/// - Warning: Although this has `public` access, it is intended for internal use and should not be used directly
	///   by host applications. The behavior of this may change without warning.
	convenience init(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy) {
		self.init()
		self.dateDecodingStrategy = dateDecodingStrategy
	}
}

/// A parser to convert dictionary into concrete object
public extension Dictionary where Key == String, Value: Any {
    func parse<T: Decodable>() -> T? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: []) else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}


public extension Dictionary {
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed])
    }
}

public extension Array {
    func toData() throws -> Data {
        return try JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed])
    }
}

public extension Bundle {

    static func getData(_ fileName: String, bundle: Bundle = Bundle.main) -> Data {
        let url = bundle.url(forResource: fileName, withExtension: "json")!
        let data = try! Data(contentsOf: url)
        return data
    }

    static func getThrowableData(_ fileName: String, bundle: Bundle = Bundle.main) throws -> Data {
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            throw SerializationError("json file not found for: \(fileName)")
        }
        return try Data(contentsOf: url)
    }
}

// MARK: - Encodable
extension Encodable {

    /// A dictionary  of the Object and its data
    public var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    }

    /// A data of the object
    public var toData: Data? {
        return try? PropertyListEncoder().encode(self)
    }

    public func toPlistData() throws -> Data {
        return try PropertyListEncoder().encode(self)
    }
}

// MARK: - Decodable
extension Decodable {
    /// Decode an object from JSONData
    /// - Parameter data: JSONData of the object
    /// - Returns: A decoded Instance object
    public static func decode(fromJsonData data: Data) -> Self? {
        guard let object = try? JSONDecoder().decode(self.self, from: data) else { return nil }
        return object
    }

    /// Decode an instance from PlistData
    /// - Parameter data: PlistData of the object
    /// - Returns: A decoded Instance Object
    public static func decode(fromPlistData data: Data) -> Self? {
        return try? PropertyListDecoder().decode(self.self, from: data)
    }

    public static func decoded(fromPlistData data: Data) throws -> Self {
        return try PropertyListDecoder().decode(self.self, from: data)
    }
}

extension Result {
    
    /// Evaluates the specified closure when the `Result` is a success, passing the unwrapped value as a parameter.
    ///
    /// Use the `withValue` function to evaluate the passed closure without modifying the `Result` instance.
    ///
    /// - Parameter closure: A closure that takes the success value of this instance.
    /// - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func withValue(_ closure: (Value) throws -> Void) rethrows -> Result {
        if case let .success(value) = self { try closure(value) }
        
        return self
    }
    
    /// Evaluates the specified closure when the `Result` is a failure, passing the unwrapped error as a parameter.
    ///
    /// Use the `withError` function to evaluate the passed closure without modifying the `Result` instance.
    ///
    /// - Parameter closure: A closure that takes the success value of this instance.
    /// - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func withError(_ closure: (Error) throws -> Void) rethrows -> Result {
        if case let .failure(error) = self { try closure(error) }
        
        return self
    }
    
    /// Evaluates the specified closure when the `Result` is a success.
    ///
    /// Use the `ifSuccess` function to evaluate the passed closure without modifying the `Result` instance.
    ///
    /// - Parameter closure: A `Void` closure.
    /// - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func ifSuccess(_ closure: () throws -> Void) rethrows -> Result {
        if value != nil { try closure() }
        return self
    }
    
    /// Evaluates the specified closure when the `Result` is a failure.
    ///
    /// Use the `ifFailure` function to evaluate the passed closure without modifying the `Result` instance.
    ///
    /// - Parameter closure: A `Void` closure.
    /// - Returns: This `Result` instance, unmodified.
    @discardableResult
    public func ifFailure(_ closure: () throws -> Void) rethrows -> Result {
        if error != nil { try closure() }
        return self
    }
}
