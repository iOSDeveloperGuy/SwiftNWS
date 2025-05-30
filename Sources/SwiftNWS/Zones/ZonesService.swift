import Foundation

/// Service for accessing zone-related endpoints of the NWS API.
public class ZonesService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new zones service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets all zones of the specified type.
    /// - Parameter type: The type of zones to get.
    /// - Returns: A collection of zones of the specified type.
    /// - Throws: An error if the request fails.
    public func getZones(type: NWSZoneType) async throws -> NWSZoneCollection {
        let endpoint = ZonesEndpoint.zones(type: type)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the zone with the specified type and ID.
    /// - Parameters:
    ///   - type: The type of the zone.
    ///   - zoneId: The ID of the zone.
    /// - Returns: The zone with the specified type and ID.
    /// - Throws: An error if the request fails.
    public func getZone(type: NWSZoneType, zoneId: String) async throws -> NWSZone {
        let endpoint = ZonesEndpoint.zone(type: type, zoneId: zoneId)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the forecast for the specified zone.
    /// - Parameters:
    ///   - type: The type of the zone.
    ///   - zoneId: The ID of the zone.
    /// - Returns: The forecast for the zone.
    /// - Throws: An error if the request fails.
    public func getForecastForZone(type: NWSZoneType, zoneId: String) async throws -> NWSZoneForecast {
        let endpoint = ZonesEndpoint.zoneForecast(type: type, zoneId: zoneId)
        return try await networkService.request(endpoint: endpoint)
    }
}

/// Endpoints for the zones service.
internal enum ZonesEndpoint: Endpoint {
    case zones(type: NWSZoneType)
    case zone(type: NWSZoneType, zoneId: String)
    case zoneForecast(type: NWSZoneType, zoneId: String)
    
    var path: String {
        switch self {
        case .zones(let type):
            return "/zones/\(type.rawValue)"
        case .zone(let type, let zoneId):
            return "/zones/\(type.rawValue)/\(zoneId)"
        case .zoneForecast(let type, let zoneId):
            return "/zones/\(type.rawValue)/\(zoneId)/forecast"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        return nil
    }
}
