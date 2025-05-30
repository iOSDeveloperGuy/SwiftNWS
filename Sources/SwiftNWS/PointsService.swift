import Foundation

/// Service for accessing point-related endpoints of the NWS API.
public class PointsService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new points service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets the point information for the specified coordinates.
    /// - Parameters:
    ///   - latitude: The latitude of the point.
    ///   - longitude: The longitude of the point.
    /// - Returns: The point information for the coordinates.
    /// - Throws: An error if the request fails.
    public func getPoint(latitude: Double, longitude: Double) async throws -> Point {
        let coordinate = Coordinate(latitude: latitude, longitude: longitude)
        let endpoint = PointsEndpoint.point(coordinate: coordinate)
        return try await networkService.request(endpoint: endpoint)
    }
}

/// Endpoints for the points service.
internal enum PointsEndpoint: Endpoint {
    case point(coordinate: Coordinate)
    
    var path: String {
        switch self {
        case .point(let coordinate):
            return "/points/\(coordinate.latitude),\(coordinate.longitude)"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
