import Foundation

/// Models for alert-related API responses.

/// Status of an alert.
public enum AlertStatus: String, Codable {
    case Actual
    case Exercise
    case System
    case Test
    case Draft
}

/// Message type of an alert.
public enum AlertMessageType: String, Codable {
    case Alert
    case Update
    case Cancel
}

/// Category of an alert.
public enum AlertCategory: String, Codable {
    case Met
    case Geo
    case Safety
    case Security
    case Rescue
    case Fire
    case Health
    case Env
    case Transport
    case Infra
    case Cbrne
    case Other
}

/// Severity of an alert.
public enum AlertSeverity: String, Codable {
    case Extreme
    case Severe
    case Moderate
    case Minor
    case Unknown
}

/// Certainty of an alert.
public enum AlertCertainty: String, Codable {
    case Observed
    case Likely
    case Possible
    case Unlikely
    case Unknown
}

/// Urgency of an alert.
public enum AlertUrgency: String, Codable {
    case Immediate
    case Expected
    case Future
    case Past
    case Unknown
}

/// Response type of an alert.
public enum AlertResponse: String, Codable {
    case Shelter
    case Evacuate
    case Prepare
    case Execute
    case Avoid
    case Monitor
    case Assess
    case allClear = "all-clear"
    case None
}

/// A reference to another alert.
public struct Reference: Codable {
    /// The ID of the referenced alert.
    public let id: String
    
    /// The identifier of the referenced alert.
    public let identifier: String
    
    /// The sender of the referenced alert.
    public let sender: String
    
    /// The date the referenced alert was sent.
    public let sent: Date
    
    private enum CodingKeys: String, CodingKey {
        case id = "@id"
        case identifier
        case sender
        case sent
    }
}

/// Geocode information for an alert.
public struct Geocode: Codable {
    /// SAME codes for the alert.
    public let SAME: [String]?
    
    /// UGC codes for the alert.
    public let UGC: [String]?
}

/// An alert from the NWS API.
public struct Alert: Codable, Identifiable {
    /// The ID of the alert.
    public let id: String
    
    /// The area description of the alert.
    public let areaDesc: String
    
    /// The geocode information for the alert.
    public let geocode: Geocode
    
    /// The zones affected by the alert.
    public let affectedZones: [URL]
    
    /// References to other alerts.
    public let references: [Reference]
    
    /// The date the alert was sent.
    public let sent: Date
    
    /// The date the alert becomes effective.
    public let effective: Date
    
    /// The date the alert onset occurs.
    public let onset: Date?
    
    /// The date the alert expires.
    public let expires: Date
    
    /// The date the alert ends.
    public let ends: Date?
    
    /// The status of the alert.
    public let status: AlertStatus
    
    /// The message type of the alert.
    public let messageType: AlertMessageType
    
    /// The category of the alert.
    public let category: AlertCategory
    
    /// The severity of the alert.
    public let severity: AlertSeverity
    
    /// The certainty of the alert.
    public let certainty: AlertCertainty
    
    /// The urgency of the alert.
    public let urgency: AlertUrgency
    
    /// The event name of the alert.
    public let event: String
    
    /// The sender of the alert.
    public let sender: String
    
    /// The name of the sender of the alert.
    public let senderName: String
    
    /// The headline of the alert.
    public let headline: String?
    
    /// The description of the alert.
    public let description: String
    
    /// Instructions for the alert.
    public let instruction: String?
    
    /// The response type of the alert.
    public let response: AlertResponse
    
    /// Additional parameters for the alert.
    public let parameters: [String: [String]]?
}

/// Pagination information for collections.
public struct Pagination: Codable {
    /// The next page URL.
    public let next: URL?
}

/// A collection of alerts.
public struct AlertCollection: Codable {
    /// A list of alert features returned by the API.
    public let alerts: [AlertFeatures]
    
    private enum CodingKeys: String, CodingKey {
        case alerts = "features"
    }
}

public struct AlertFeatures: Codable {
    /// The detailed alert information.
    let alert: Alert
    
    private enum CodingKeys: String, CodingKey {
        case alert = "properties"
    }
}

/// Count of active alerts.
public struct AlertCount: Codable {
    /// The total number of active alerts.
    public let total: Int
    
    /// The total number of active alerts affecting land zones.
    public let land: Int
    
    /// The total number of active alerts affecting marine zones.
    public let marine: Int
    
    /// Active alerts by region.
    public let regions: [String: Int]
    
    /// Active alerts by area.
    public let areas: [String: Int]
    
    /// Active alerts by zone.
    public let zones: [String: Int]
}

/// An alert type.
public struct AlertType: Codable {
    /// The ID of the alert type.
    public let id: String
    
    /// The name of the alert type.
    public let name: String
}
