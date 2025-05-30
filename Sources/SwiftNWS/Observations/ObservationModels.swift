import Foundation

/// Models for observation-related API responses.

/// An observation from the NWS API.
public struct NWSObservation: Codable, Sendable {
    /// The ID of the observation.
    public let id: String
    
    /// The properties of the observation.
    public let properties: NWSObservationProperties
}

/// A collection of observations.
public struct NWSObservationCollection: Codable, Sendable {
    /// The observations in the collection.
    public let features: [NWSObservation]
}

/// Properties of an observation.
public struct NWSObservationProperties: Codable, Sendable {
    /// The ID of the observation.
    public let id: String
    
    /// The type of the observation.
    public let type: String
    
    /// The station identifier of the observation.
    public let station: String
    
    /// The timestamp of the observation.
    public let timestamp: Date
    
    /// The raw message of the observation.
    public let rawMessage: String?
    
    /// The text description of the observation.
    public let textDescription: String?
    
    /// The icon for the observation.
    public let icon: URL?
    
    /// The present weather for the observation.
    public let presentWeather: [NWSPresentWeather]?
    
    /// The temperature for the observation.
    public let temperature: NWSQuantitativeValue?
    
    /// The dewpoint for the observation.
    public let dewpoint: NWSQuantitativeValue?
    
    /// The wind direction for the observation.
    public let windDirection: NWSQuantitativeValue?
    
    /// The wind speed for the observation.
    public let windSpeed: NWSQuantitativeValue?
    
    /// The wind gust for the observation.
    public let windGust: NWSQuantitativeValue?
    
    /// The barometric pressure for the observation.
    public let barometricPressure: NWSQuantitativeValue?
    
    /// The sea level pressure for the observation.
    public let seaLevelPressure: NWSQuantitativeValue?
    
    /// The visibility for the observation.
    public let visibility: NWSQuantitativeValue?
    
    /// The maximum temperature in the past 24 hours.
    public let maxTemperatureLast24Hours: NWSQuantitativeValue?
    
    /// The minimum temperature in the past 24 hours.
    public let minTemperatureLast24Hours: NWSQuantitativeValue?
    
    /// The precipitation in the past hour.
    public let precipitationLastHour: NWSQuantitativeValue?
    
    /// The precipitation in the past 3 hours.
    public let precipitationLast3Hours: NWSQuantitativeValue?
    
    /// The precipitation in the past 6 hours.
    public let precipitationLast6Hours: NWSQuantitativeValue?
    
    /// The relative humidity for the observation.
    public let relativeHumidity: NWSQuantitativeValue?
    
    /// The wind chill for the observation.
    public let windChill: NWSQuantitativeValue?
    
    /// The heat index for the observation.
    public let heatIndex: NWSQuantitativeValue?
    
    /// The cloud layers for the observation.
    public let cloudLayers: [NWSCloudLayer]?
    
    enum CodingKeys: String, CodingKey {
        case id = "@id"
        case type = "@type"
        case station
        case timestamp
        case rawMessage
        case textDescription
        case icon
        case presentWeather
        case temperature
        case dewpoint
        case windDirection
        case windSpeed
        case windGust
        case barometricPressure
        case seaLevelPressure
        case visibility
        case maxTemperatureLast24Hours
        case minTemperatureLast24Hours
        case precipitationLastHour
        case precipitationLast3Hours
        case precipitationLast6Hours
        case relativeHumidity
        case windChill
        case heatIndex
        case cloudLayers
    }
}

/// A quantitative value with a unit.
public struct NWSQuantitativeValue: Codable, Sendable {
    /// The value of the measurement.
    public let value: Double?
    
    /// The unit code of the measurement.
    public let unitCode: String?
    
    /// The quality control flag of the measurement.
    public let qualityControl: String?
}

/// A cloud layer observation.
public struct NWSCloudLayer: Codable, Sendable {
    /// The base of the cloud layer.
    public let base: NWSQuantitativeValue?
    
    /// The amount of cloud cover.
    public let amount: String?
}

/// A present weather observation.
public struct NWSPresentWeather: Codable, Sendable {
    /// The intensity of the weather (e.g., light, moderate, heavy).
    public let intensity: String?
    
    /// A modifier for the weather (e.g., patches, blowing).
    public let modifier: String?
    
    /// The type of weather (e.g., fog, rain, snow).
    public let weather: String?
    
    /// The raw string representing the weather.
    public let rawString: String?
    
    /// Indicates if the weather is in the vicinity.
    public let inVicinity: Bool?
}
