import Foundation

/// Models for forecast-related API responses.

/// A forecast from the NWS API.
public struct Forecast: Codable {
    /// The properties of the forecast.
    public let properties: ForecastProperties
}

/// Properties of a forecast.
public struct ForecastProperties: Codable {
    /// The units of the forecast.
    public let units: String
    
    /// The forecast generator for the forecast.
    public let forecastGenerator: String
    
    /// The date the forecast was generated.
    public let generatedAt: Date
    
    /// The date the forecast was last modified.
    public let updateTime: Date
    
    /// The office that issued the forecast.
    public let validTimes: String
    
    /// The elevation of the forecast point.
    public let elevation: Elevation
    
    /// The periods of the forecast.
    public let periods: [ForecastPeriod]
}

/// Elevation information.
public struct Elevation: Codable {
    /// The value of the elevation.
    public let value: Double
    
    /// The unit of the elevation.
    public let unitCode: String
}

/// A period in a forecast.
public struct ForecastPeriod: Codable, Identifiable {
    /// The number of the period.
    public let number: Int
    
    /// The name of the period.
    public let name: String
    
    /// The start time of the period.
    public let startTime: Date
    
    /// The end time of the period.
    public let endTime: Date
    
    /// Whether the period is during the day.
    public let isDaytime: Bool
    
    /// The temperature during the period.
    public let temperature: Int
    
    /// The unit of the temperature.
    public let temperatureUnit: String
    
    /// The temperature trend during the period.
    public let temperatureTrend: String?
    
    /// The wind speed during the period.
    public let windSpeed: String
    
    /// The wind direction during the period.
    public let windDirection: String
    
    /// The icon URL for the period.
    public let icon: URL
    
    /// The short forecast for the period.
    public let shortForecast: String
    
    /// The detailed forecast for the period.
    public let detailedForecast: String
    
    /// The ID of the period.
    public var id: Int { number }
}

/// A point from the NWS API.
public struct Point: Codable {
    /// The ID of the point.
    public let id: String
    
    /// The properties of the point.
    public let properties: PointProperties
}

/// Properties of a point.
public struct PointProperties: Codable {
    /// The ID of the grid.
    public let gridId: String
    
    /// The X coordinate of the grid point.
    public let gridX: Int
    
    /// The Y coordinate of the grid point.
    public let gridY: Int
    
    /// The forecast office for the point.
    public let forecast: URL
    
    /// The hourly forecast for the point.
    public let forecastHourly: URL
    
    /// The forecast grid data for the point.
    public let forecastGridData: URL
    
    /// The observation stations for the point.
    public let observationStations: URL
    
    /// The county for the point.
    public let county: URL
    
    /// The fire weather zone for the point.
    public let fireWeatherZone: URL
    
    /// The time zone for the point.
    public let timeZone: String
    
    /// The radar station for the point.
    public let radarStation: String?
}
