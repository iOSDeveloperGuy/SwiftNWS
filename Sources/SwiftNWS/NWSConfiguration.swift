import Foundation

/// Configuration for the NWS client.
public struct NWSConfiguration {
    /// The base URL for the NWS API.
    public let baseURL: URL
    
    /// The user agent string to use for API requests.
    public var userAgent: String
    
    /// The default format to use for API responses.
    public var defaultFormat: NWSFormat
    
    /// The timeout interval for API requests in seconds.
    public var timeoutInterval: TimeInterval
    
    /// The default configuration for the NWS client.
    public static let `default` = NWSConfiguration(
        baseURL: URL(string: "https://api.weather.gov")!,
        userAgent: "NWSSwiftWrapper/1.0",
        defaultFormat: .geoJSON,
        timeoutInterval: 30.0
    )
    
    /// Initializes a new configuration with the specified values.
    /// - Parameters:
    ///   - baseURL: The base URL for the NWS API. Defaults to "https://api.weather.gov".
    ///   - userAgent: The user agent string to use for API requests. Defaults to "NWSSwiftWrapper/1.0".
    ///   - defaultFormat: The default format to use for API responses. Defaults to `.geoJSON`.
    ///   - timeoutInterval: The timeout interval for API requests in seconds. Defaults to 30.0.
    public init(
        baseURL: URL = URL(string: "https://api.weather.gov")!,
        userAgent: String = "NWSSwiftWrapper/1.0",
        defaultFormat: NWSFormat = .geoJSON,
        timeoutInterval: TimeInterval = 30.0
    ) {
        self.baseURL = baseURL
        self.userAgent = userAgent
        self.defaultFormat = defaultFormat
        self.timeoutInterval = timeoutInterval
    }
}
