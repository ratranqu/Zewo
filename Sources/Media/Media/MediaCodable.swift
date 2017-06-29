import Venice
import Core

public typealias MediaCodable = MediaEncodable & MediaDecodable

public enum MediaCodingError : Error {
    case noDefaultContentType
    case unsupportedMediaType
}

public protocol MediaEncodable : Encodable {
    static var encodingMedia: [EncodingMedia.Type] { get }
}

extension MediaEncodable {
    public static var encodingMedia: [EncodingMedia.Type] {
        return [JSON.self]
    }
}

extension MediaEncodable {
    public static func defaultEncodingMedia() throws -> EncodingMedia.Type {
        guard let media = encodingMedia.first else {
            throw MediaCodingError.noDefaultContentType
        }
        
        return media
    }
    
    public static func encodingMedia(for mediaType: MediaType) throws -> EncodingMedia.Type {
        for media in encodingMedia where media.mediaType.matches(other: mediaType) {
            return media
        }
        
        throw MediaCodingError.unsupportedMediaType
    }
}

public protocol MediaDecodable : Decodable {
    static var decodingMedia: [DecodingMedia.Type] { get }
}

extension MediaDecodable {
    public static var decodingMedia: [DecodingMedia.Type] {
        return [JSON.self]
    }
}

extension MediaDecodable {
    public static func defaultDecodingMedia() throws -> DecodingMedia.Type {
        guard let media = decodingMedia.first else {
            throw MediaCodingError.noDefaultContentType
        }
        
        return media
    }
    
    public static func decodingMedia(for mediaType: MediaType) throws -> DecodingMedia.Type {
        for media in decodingMedia where media.mediaType.matches(other: mediaType) {
            return media
        }
        
        throw MediaCodingError.unsupportedMediaType
    }
}
