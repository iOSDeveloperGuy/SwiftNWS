import Foundation

/// The main entry point for interacting with the National Weather Service API.
public class NWSClient {
    /// Configuration for the NWS client
    public var configuration: NWSConfiguration
    
    /// Service for accessing alert-related endpoints
    public lazy var alerts: AlertsService = {
        return AlertsService(networkService: self.networkService)
    }()
    
    /// Service for accessing forecast-related endpoints
    public lazy var forecasts: ForecastsService = {
        return ForecastsService(networkService: self.networkService)
    }()
    
    /// Service for accessing observation-related endpoints
    public lazy var observations: ObservationsService = {
        return ObservationsService(networkService: self.networkService)
    }()
    
    /// Service for accessing station-related endpoints
    public lazy var stations: StationsService = {
        return StationsService(networkService: self.networkService)
    }()
    
    /// Service for accessing point-related endpoints
    public lazy var points: NWSPointsService = {
        return NWSPointsService(networkService: self.networkService)
    }()
    
    /// Service for accessing zone-related endpoints
    public lazy var zones: ZonesService = {
        return ZonesService(networkService: self.networkService)
    }()
    
    /// Service for accessing office-related endpoints
    public lazy var offices: OfficesService = {
        return OfficesService(networkService: self.networkService)
    }()
    
    /// Internal network service for making API requests
    internal let networkService: NetworkService
    
    /// Initializes a new NWS client with the specified configuration.
    /// - Parameter configuration: The configuration to use. Defaults to `.default`.
    public init(configuration: NWSConfiguration = .default) {
        self.configuration = configuration
        self.networkService = NetworkService(configuration: configuration)
    }
    
    /// Sets the user agent for API requests.
    /// - Parameter userAgent: The user agent string to use.
    public func setUserAgent(_ userAgent: String) {
        self.configuration.userAgent = userAgent
    }
}
