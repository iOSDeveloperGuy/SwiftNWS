import Foundation

/// Models for zone-related API responses.

/// Type of a zone.
public enum ZoneType: String, Codable {
    case forecast
    case fire
    case county
    case publicMarineZone = "public_marine"
    case coastalMarineZone = "coastal_marine"
    case offshore
    case highSeas = "high_seas"
}

/// A zone from the NWS API.
public struct Zone: Codable {
    /// The ID of the zone.
    public let id: String
    
    /// The properties of the zone.
    public let properties: ZoneProperties
}

/// A collection of zones.
public struct ZoneCollection: Codable {
    /// The zones in the collection.
    public let features: [Zone]
    
    /// Pagination information for the collection.
    public let pagination: Pagination?
}

/// Properties of a zone.
public struct ZoneProperties: Codable {
    /// The ID of the zone.
    public let id: String
    
    /// The type of the zone.
    public let type: String
    
    /// The name of the zone.
    public let name: String
    
    /// The effective date of the zone.
    public let effectiveDate: Date?
    
    /// The expiration date of the zone.
    public let expirationDate: Date?
    
    /// The state of the zone.
    public let state: String?
    
    /// The forecast office for the zone.
    public let forecastOffice: URL?
    
    /// The time zone of the zone.
    public let timeZone: [String]?
    
    /// The radar station for the zone.
    public let radarStation: String?
}

/// A forecast for a zone.
public struct ZoneForecast: Codable {
    /// The properties of the zone forecast.
    public let properties: ZoneForecastProperties
}

/// Properties of a zone forecast.
public struct ZoneForecastProperties: Codable {
    /// The date the forecast was updated.
    public let updated: Date
    
    /// The periods of the forecast.
    public let periods: [ZoneForecastPeriod]
}

/// A period in a zone forecast.
public struct ZoneForecastPeriod: Codable {
    /// The number of the period.
    public let number: Int
    
    /// The name of the period.
    public let name: String
    
    /// The detailed forecast for the period.
    public let detailedForecast: String
}
