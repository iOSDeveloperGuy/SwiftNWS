import Foundation

/// Service for accessing observation-related endpoints of the NWS API.
public class ObservationsService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new observations service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets the latest observations for the specified station.
    /// - Parameter stationId: The ID of the station.
    /// - Returns: The latest observations for the station.
    /// - Throws: An error if the request fails.
    public func getLatestObservations(stationId: String) async throws -> Observation {
        let endpoint = ObservationsEndpoint.stationObservations(stationId: stationId)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the observations for the specified station within the specified time period.
    /// - Parameters:
    ///   - stationId: The ID of the station.
    ///   - start: The start date of the time period.
    ///   - end: The end date of the time period.
    /// - Returns: The observations for the station within the time period.
    /// - Throws: An error if the request fails.
    public func getObservations(stationId: String, start: Date, end: Date) async throws -> ObservationCollection {
        let startString = start.toISO8601()
        let endString = end.toISO8601()
        
        let queryItems = [
            URLQueryItem(name: "start", value: startString),
            URLQueryItem(name: "end", value: endString)
        ]
        
        let endpoint = ObservationsEndpoint.stationObservationsWithTime(stationId: stationId, queryItems: queryItems)
        return try await networkService.request(endpoint: endpoint)
    }
}

/// Endpoints for the observations service.
internal enum ObservationsEndpoint: Endpoint {
    case stationObservations(stationId: String)
    case stationObservationsWithTime(stationId: String, queryItems: [URLQueryItem])
    
    var path: String {
        switch self {
        case .stationObservations(let stationId), .stationObservationsWithTime(let stationId, _):
            return "/stations/\(stationId)/observations"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .stationObservations:
            return nil
        case .stationObservationsWithTime(_, let queryItems):
            return queryItems
        }
    }
}
