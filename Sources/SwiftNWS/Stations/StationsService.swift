import Foundation

/// Service for accessing station-related endpoints of the NWS API.
public class StationsService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new stations service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets all stations.
    /// - Returns: A collection of stations.
    /// - Throws: An error if the request fails.
    public func getAllStations() async throws -> StationCollection {
        let endpoint = StationsEndpoint.stations
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the station with the specified ID.
    /// - Parameter stationId: The ID of the station.
    /// - Returns: The station with the specified ID.
    /// - Throws: An error if the request fails.
    public func getStation(stationId: String) async throws -> Station {
        let endpoint = StationsEndpoint.station(stationId: stationId)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the stations for the specified point.
    /// - Parameters:
    ///   - latitude: The latitude of the point.
    ///   - longitude: The longitude of the point.
    /// - Returns: A collection of stations for the point.
    /// - Throws: An error if the request fails.
    public func getStationsForPoint(latitude: Double, longitude: Double) async throws -> StationCollection {
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        
        // First, get the grid point for the coordinate
        let pointEndpoint = PointsEndpoint.point(coordinate: coordinate)
        let point: Point = try await networkService.request(endpoint: pointEndpoint)
        
        // Then, get the observation stations for the grid point
        let stationsEndpoint = StationsEndpoint.stationsForPoint(url: point.properties.observationStations)
        return try await networkService.request(endpoint: stationsEndpoint)
    }
}

/// Endpoints for the stations service.
internal enum StationsEndpoint: Endpoint {
    case stations
    case station(stationId: String)
    case stationsForPoint(url: URL)
    
    var path: String {
        switch self {
        case .stations:
            return "/stations"
        case .station(let stationId):
            return "/stations/\(stationId)"
        case .stationsForPoint(let url):
            // Extract the path from the URL
            return url.path
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
