import Foundation

/// Models for station-related API responses.

/// A station from the NWS API.
public struct Station: Codable, Sendable {
    /// The ID of the station.
    public let id: String
    
    /// The properties of the station.
    public let properties: StationProperties
}

/// A collection of stations.
public struct StationCollection: Codable, Sendable {
    /// The stations in the collection.
    public let features: [Station]
    
}

/// Properties of a station.
public struct StationProperties: Codable, Sendable {
    /// The ID of the station.
    public let id: String
    
    /// The name of the station.
    public let name: String
    
    /// The time zone of the station.
    public let timeZone: String?
    
    /// The forecast office for the station.
    public let forecast: URL?
    
    /// The county for the station.
    public let county: URL?
    
    /// The fire weather zone for the station.
    public let fireWeatherZone: URL?
    
    /// The elevation of the station.
    public let elevation: Elevation?
    
    /// The status of the station.
    public let status: String?
    
    /// The URL for observations from the station.
    public let observationStations: URL?
    
    /// The station identifier.
    public let stationIdentifier: String
    
    /// The station type.
    public let stationType: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case name
        case timeZone
        case forecast
        case county
        case fireWeatherZone
        case elevation
        case status
        case observationStations
        case stationIdentifier
        case stationType
    }
}
