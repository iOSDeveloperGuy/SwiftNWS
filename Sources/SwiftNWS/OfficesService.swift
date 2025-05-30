import Foundation

/// Service for accessing office-related endpoints of the NWS API.
public class OfficesService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new offices service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets all offices.
    /// - Returns: A collection of offices.
    /// - Throws: An error if the request fails.
    public func getAllOffices() async throws -> OfficeCollection {
        let endpoint = OfficesEndpoint.offices
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the office with the specified ID.
    /// - Parameter officeId: The ID of the office.
    /// - Returns: The office with the specified ID.
    /// - Throws: An error if the request fails.
    public func getOffice(officeId: String) async throws -> Office {
        let endpoint = OfficesEndpoint.office(officeId: officeId)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the headlines for the specified office.
    /// - Parameter officeId: The ID of the office.
    /// - Returns: The headlines for the office.
    /// - Throws: An error if the request fails.
    public func getHeadlinesForOffice(officeId: String) async throws -> HeadlineCollection {
        let endpoint = OfficesEndpoint.officeHeadlines(officeId: officeId)
        return try await networkService.request(endpoint: endpoint)
    }
}

/// Endpoints for the offices service.
internal enum OfficesEndpoint: Endpoint {
    case offices
    case office(officeId: String)
    case officeHeadlines(officeId: String)
    
    var path: String {
        switch self {
        case .offices:
            return "/offices"
        case .office(let officeId):
            return "/offices/\(officeId)"
        case .officeHeadlines(let officeId):
            return "/offices/\(officeId)/headlines"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
