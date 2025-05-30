import Foundation

/// A utility struct for representing geographic coordinates.
public struct Coordinate: Codable, Equatable {
    /// The latitude component of the coordinate.
    public let latitude: Double
    
    /// The longitude component of the coordinate.
    public let longitude: Double
    
    /// Initializes a new coordinate with the specified latitude and longitude.
    /// - Parameters:
    ///   - latitude: The latitude component of the coordinate.
    ///   - longitude: The longitude component of the coordinate.
    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    /// String representation in the format required by the API.
    public var stringValue: String {
        return "\(latitude),\(longitude)"
    }
}

/// Extensions to Date for handling the various date formats used by the API.
extension Date {
    /// Creates a Date from an ISO8601 formatted string.
    /// - Parameter string: The ISO8601 formatted string.
    /// - Returns: A Date if the string could be parsed, nil otherwise.
    static func fromISO8601(_ string: String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.date(from: string)
    }
    
    /// Returns an ISO8601 formatted string representation of the date.
    /// - Returns: An ISO8601 formatted string.
    func toISO8601() -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}
