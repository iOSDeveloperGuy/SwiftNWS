import Foundation

/// Service for accessing forecast-related endpoints of the NWS API.
public class ForecastsService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new forecasts service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets the forecast for the specified point.
    /// - Parameters:
    ///   - latitude: The latitude of the point.
    ///   - longitude: The longitude of the point.
    /// - Returns: The forecast for the point.
    /// - Throws: An error if the request fails.
    public func getForecastForPoint(latitude: Double, longitude: Double) async throws -> NWSForecast {
        let coordinate = NWSCoordinate(latitude: latitude, longitude: longitude)
        
        // First, get the grid point for the coordinate
        let pointEndpoint = PointsEndpoint.point(coordinate: coordinate)
        let point: NWSPoint = try await networkService.request(endpoint: pointEndpoint)
        
        // Then, get the forecast for the grid point
        let forecastEndpoint = ForecastsEndpoint.gridpointForecast(
            office: point.properties.gridId,
            gridX: point.properties.gridX,
            gridY: point.properties.gridY
        )
        
        return try await networkService.request(endpoint: forecastEndpoint)
    }
    
    /// Gets the hourly forecast for the specified point.
    /// - Parameters:
    ///   - latitude: The latitude of the point.
    ///   - longitude: The longitude of the point.
    /// - Returns: The hourly forecast for the point.
    /// - Throws: An error if the request fails.
    public func getHourlyForecastForPoint(latitude: Double, longitude: Double) async throws -> NWSForecast {
        let coordinate = NWSCoordinate(latitude: latitude, longitude: longitude)
        
        // First, get the grid point for the coordinate
        let pointEndpoint = PointsEndpoint.point(coordinate: coordinate)
        let point: NWSPoint = try await networkService.request(endpoint: pointEndpoint)
        
        // Then, get the hourly forecast for the grid point
        let forecastEndpoint = ForecastsEndpoint.gridpointForecastHourly(
            office: point.properties.gridId,
            gridX: point.properties.gridX,
            gridY: point.properties.gridY
        )
        
        return try await networkService.request(endpoint: forecastEndpoint)
    }
    
    /// Gets the forecast for the specified grid point.
    /// - Parameters:
    ///   - office: The office ID.
    ///   - gridX: The X coordinate of the grid point.
    ///   - gridY: The Y coordinate of the grid point.
    /// - Returns: The forecast for the grid point.
    /// - Throws: An error if the request fails.
    public func getForecastForGridPoint(office: String, gridX: Int, gridY: Int) async throws -> NWSForecast {
        let endpoint = ForecastsEndpoint.gridpointForecast(office: office, gridX: gridX, gridY: gridY)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the hourly forecast for the specified grid point.
    /// - Parameters:
    ///   - office: The office ID.
    ///   - gridX: The X coordinate of the grid point.
    ///   - gridY: The Y coordinate of the grid point.
    /// - Returns: The hourly forecast for the grid point.
    /// - Throws: An error if the request fails.
    public func getHourlyForecastForGridPoint(office: String, gridX: Int, gridY: Int) async throws -> NWSForecast {
        let endpoint = ForecastsEndpoint.gridpointForecastHourly(office: office, gridX: gridX, gridY: gridY)
        return try await networkService.request(endpoint: endpoint)
    }
}

/// Endpoints for the forecasts service.
internal enum ForecastsEndpoint: Endpoint {
    case gridpointForecast(office: String, gridX: Int, gridY: Int)
    case gridpointForecastHourly(office: String, gridX: Int, gridY: Int)
    
    var path: String {
        switch self {
        case .gridpointForecast(let office, let gridX, let gridY):
            return "/gridpoints/\(office)/\(gridX),\(gridY)/forecast"
        case .gridpointForecastHourly(let office, let gridX, let gridY):
            return "/gridpoints/\(office)/\(gridX),\(gridY)/forecast/hourly"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
