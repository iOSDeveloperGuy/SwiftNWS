import Foundation

/// Service for accessing alert-related endpoints of the NWS API.
public class AlertsService {
    /// The network service used to make API requests.
    private let networkService: NetworkService
    
    /// Initializes a new alerts service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }
    
    /// Gets all alerts matching the specified criteria.
    /// - Parameters:
    ///   - status: Filter alerts by status.
    ///   - messageType: Filter alerts by message type.
    ///   - event: Filter alerts by event name.
    ///   - code: Filter alerts by code.
    ///   - area: Filter alerts by area.
    ///   - point: Filter alerts by point.
    ///   - region: Filter alerts by region.
    ///   - region_type: Filter alerts by region type.
    ///   - zone: Filter alerts by zone.
    ///   - urgency: Filter alerts by urgency.
    ///   - severity: Filter alerts by severity.
    ///   - certainty: Filter alerts by certainty.
    ///   - limit: Limit the number of results.
    /// - Returns: A collection of alerts matching the criteria.
    /// - Throws: An error if the request fails.
    public func getAlerts(
        status: AlertStatus? = nil,
        messageType: AlertMessageType? = nil,
        event: String? = nil,
        code: String? = nil,
        area: String? = nil,
        point: Coordinate? = nil,
        region: String? = nil,
        region_type: String? = nil,
        zone: String? = nil,
        urgency: AlertUrgency? = nil,
        severity: AlertSeverity? = nil,
        certainty: AlertCertainty? = nil,
        limit: Int? = nil
    ) async throws -> AlertCollection {
        var queryItems = [URLQueryItem]()
        
        if let status = status {
            queryItems.append(URLQueryItem(name: "status", value: status.rawValue))
        }
        
        if let messageType = messageType {
            queryItems.append(URLQueryItem(name: "message_type", value: messageType.rawValue))
        }
        
        if let event = event {
            queryItems.append(URLQueryItem(name: "event", value: event))
        }
        
        if let code = code {
            queryItems.append(URLQueryItem(name: "code", value: code))
        }
        
        if let area = area {
            queryItems.append(URLQueryItem(name: "area", value: area))
        }
        
        if let point = point {
            queryItems.append(URLQueryItem(name: "point", value: point.stringValue))
        }
        
        if let region = region {
            queryItems.append(URLQueryItem(name: "region", value: region))
        }
        
        if let region_type = region_type {
            queryItems.append(URLQueryItem(name: "region_type", value: region_type))
        }
        
        if let zone = zone {
            queryItems.append(URLQueryItem(name: "zone", value: zone))
        }
        
        if let urgency = urgency {
            queryItems.append(URLQueryItem(name: "urgency", value: urgency.rawValue))
        }
        
        if let severity = severity {
            queryItems.append(URLQueryItem(name: "severity", value: severity.rawValue))
        }
        
        if let certainty = certainty {
            queryItems.append(URLQueryItem(name: "certainty", value: certainty.rawValue))
        }
        
        if let limit = limit {
            queryItems.append(URLQueryItem(name: "limit", value: String(limit)))
        }
        
        let endpoint = AlertsEndpoint.alerts(queryItems: queryItems)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets all currently active alerts.
    /// - Returns: A collection of active alerts.
    /// - Throws: An error if the request fails.
    public func getActiveAlerts() async throws -> AlertCollection {
        let endpoint = AlertsEndpoint.activeAlerts
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets the count of active alerts, broken down by various categories.
    /// - Returns: The count of active alerts.
    /// - Throws: An error if the request fails.
    public func getActiveAlertCount() async throws -> AlertCount {
        let endpoint = AlertsEndpoint.activeAlertCount
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets active alerts for the specified zone.
    /// - Parameter zoneId: The ID of the zone.
    /// - Returns: A collection of active alerts for the zone.
    /// - Throws: An error if the request fails.
    public func getActiveAlertsForZone(_ zoneId: String) async throws -> AlertCollection {
        let endpoint = AlertsEndpoint.activeAlertsForZone(zoneId: zoneId)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets active alerts for the specified area.
    /// - Parameter area: The area (state or marine region).
    /// - Returns: A collection of active alerts for the area.
    /// - Throws: An error if the request fails.
    public func getActiveAlertsForArea(_ area: String) async throws -> AlertCollection {
        let endpoint = AlertsEndpoint.activeAlertsForArea(area: area)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets active alerts for the specified marine region.
    /// - Parameter region: The marine region.
    /// - Returns: A collection of active alerts for the region.
    /// - Throws: An error if the request fails.
    public func getActiveAlertsForRegion(_ region: String) async throws -> AlertCollection {
        let endpoint = AlertsEndpoint.activeAlertsForRegion(region: region)
        return try await networkService.request(endpoint: endpoint)
    }
    
    /// Gets a list of recognized event types.
    /// - Returns: A list of alert types.
    /// - Throws: An error if the request fails.
    public func getAlertTypes() async throws -> [AlertType] {
        let endpoint = AlertsEndpoint.alertTypes
        return try await networkService.request(endpoint: endpoint)
    }
}

/// Endpoints for the alerts service.
internal enum AlertsEndpoint: Endpoint {
    case alerts(queryItems: [URLQueryItem])
    case activeAlerts
    case activeAlertCount
    case activeAlertsForZone(zoneId: String)
    case activeAlertsForArea(area: String)
    case activeAlertsForRegion(region: String)
    case alertTypes
    
    var path: String {
        switch self {
        case .alerts:
            return "/alerts"
        case .activeAlerts:
            return "/alerts/active"
        case .activeAlertCount:
            return "/alerts/active/count"
        case .activeAlertsForZone(let zoneId):
            return "/alerts/active/zone/\(zoneId)"
        case .activeAlertsForArea(let area):
            return "/alerts/active/area/\(area)"
        case .activeAlertsForRegion(let region):
            return "/alerts/active/region/\(region)"
        case .alertTypes:
            return "/alerts/types"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .alerts(let queryItems):
            return queryItems.isEmpty ? nil : queryItems
        default:
            return nil
        }
    }
}
