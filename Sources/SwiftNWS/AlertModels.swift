import Foundation

/// Models for alert-related API responses.

/// Status of an alert.
public enum AlertStatus: String, Codable {
    case actual
    case exercise
    case system
    case test
    case draft
}

/// Message type of an alert.
public enum AlertMessageType: String, Codable {
    case alert
    case update
    case cancel
}

/// Category of an alert.
public enum AlertCategory: String, Codable {
    case met
    case geo
    case safety
    case security
    case rescue
    case fire
    case health
    case env
    case transport
    case infra
    case cbrne
    case other
}

/// Severity of an alert.
public enum AlertSeverity: String, Codable {
    case extreme
    case severe
    case moderate
    case minor
    case unknown
}

/// Certainty of an alert.
public enum AlertCertainty: String, Codable {
    case observed
    case likely
    case possible
    case unlikely
    case unknown
}

/// Urgency of an alert.
public enum AlertUrgency: String, Codable {
    case immediate
    case expected
    case future
    case past
    case unknown
}

/// Response type of an alert.
public enum AlertResponse: String, Codable {
    case shelter
    case evacuate
    case prepare
    case execute
    case avoid
    case monitor
    case assess
    case allClear = "all-clear"
    case none
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
    /// The title of the collection.
    public let title: String?
    
    /// The date the collection was updated.
    public let updated: Date?
    
    /// The alerts in the collection.
    public let features: [Alert]
    
    /// Pagination information for the collection.
    public let pagination: Pagination?
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
