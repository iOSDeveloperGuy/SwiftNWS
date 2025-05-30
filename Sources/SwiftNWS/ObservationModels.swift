import Foundation

/// Models for observation-related API responses.

/// An observation from the NWS API.
public struct Observation: Codable {
    /// The ID of the observation.
    public let id: String
    
    /// The properties of the observation.
    public let properties: ObservationProperties
}

/// A collection of observations.
public struct ObservationCollection: Codable {
    /// The observations in the collection.
    public let features: [Observation]
}

/// Properties of an observation.
public struct ObservationProperties: Codable {
    /// The ID of the observation.
    public let id: String
    
    /// The class of the observation.
    public let `class`: String
    
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
    public let presentWeather: String?
    
    /// The temperature for the observation.
    public let temperature: QuantitativeValue?
    
    /// The dewpoint for the observation.
    public let dewpoint: QuantitativeValue?
    
    /// The wind direction for the observation.
    public let windDirection: QuantitativeValue?
    
    /// The wind speed for the observation.
    public let windSpeed: QuantitativeValue?
    
    /// The wind gust for the observation.
    public let windGust: QuantitativeValue?
    
    /// The barometric pressure for the observation.
    public let barometricPressure: QuantitativeValue?
    
    /// The sea level pressure for the observation.
    public let seaLevelPressure: QuantitativeValue?
    
    /// The visibility for the observation.
    public let visibility: QuantitativeValue?
    
    /// The maximum temperature in the past 24 hours.
    public let maxTemperatureLast24Hours: QuantitativeValue?
    
    /// The minimum temperature in the past 24 hours.
    public let minTemperatureLast24Hours: QuantitativeValue?
    
    /// The precipitation in the past hour.
    public let precipitationLastHour: QuantitativeValue?
    
    /// The precipitation in the past 3 hours.
    public let precipitationLast3Hours: QuantitativeValue?
    
    /// The precipitation in the past 6 hours.
    public let precipitationLast6Hours: QuantitativeValue?
    
    /// The relative humidity for the observation.
    public let relativeHumidity: QuantitativeValue?
    
    /// The wind chill for the observation.
    public let windChill: QuantitativeValue?
    
    /// The heat index for the observation.
    public let heatIndex: QuantitativeValue?
    
    /// The cloud layers for the observation.
    public let cloudLayers: [CloudLayer]?
}

/// A quantitative value with a unit.
public struct QuantitativeValue: Codable {
    /// The value of the measurement.
    public let value: Double?
    
    /// The unit code of the measurement.
    public let unitCode: String?
    
    /// The quality control flag of the measurement.
    public let qualityControl: String?
}

/// A cloud layer observation.
public struct CloudLayer: Codable {
    /// The base of the cloud layer.
    public let base: QuantitativeValue?
    
    /// The amount of cloud cover.
    public let amount: String?
}
