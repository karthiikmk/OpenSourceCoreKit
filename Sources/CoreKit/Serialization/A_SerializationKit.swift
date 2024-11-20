import Foundation

public typealias DataCoder = CanDecode & CanEncode

public struct SerializationKit {

    public static func decode<Decoder>(
        _ data: Data,
        _ decoder: Decoder
    ) -> Result<Decoder.Object, Error> where Decoder: CanDecode {
        return decoder.decode(data)
    }
}
