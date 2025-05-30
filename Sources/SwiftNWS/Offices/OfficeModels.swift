import Foundation

/// Models for office-related API responses.

/// An office from the NWS API.
public struct Office: Codable, Sendable {
    /// The ID of the office.
    public let id: String
    
    /// The properties of the office.
    public let properties: OfficeProperties
}

/// A collection of offices.
@available(*, deprecated, message: "No longer supported")
public struct OfficeCollection: Codable, Sendable {
    /// The offices in the collection.
    public let features: [Office]
    
    /// Pagination information for the collection.
    public let pagination: Pagination?
}

/// Properties of an office.
public struct OfficeProperties: Codable, Sendable {
    /// The ID of the office.
    public let id: String
    
    /// The name of the office.
    public let name: String
    
    /// The address of the office.
    public let address: OfficeAddress?
    
    /// The telephone number of the office.
    public let telephone: String?
    
    /// The fax number of the office.
    public let fax: String?
    
    /// The email address of the office.
    public let email: String?
    
    /// The time zone of the office.
    public let timeZone: [String]?
    
    /// The approval time of the office.
    public let approvalTime: Date?
    
    /// The counties served by the office.
    public let counties: URL?
    
    /// The fire weather zones served by the office.
    public let fireWeatherZones: URL?
    
    /// The forecast zones served by the office.
    public let forecastZones: URL?
}

/// Address of an office.
public struct OfficeAddress: Codable, Sendable {
    /// The street address of the office.
    public let streetAddress: String?
    
    /// The extended address of the office.
    public let extendedAddress: String?
    
    /// The city of the office.
    public let city: String?
    
    /// The state of the office.
    public let state: String?
    
    /// The postal code of the office.
    public let postalCode: String?
}

/// A headline from the NWS API.
public struct Headline: Codable, Sendable {
    /// The ID of the headline.
    public let id: String
    
    /// The properties of the headline.
    public let properties: HeadlineProperties
}

/// A collection of headlines.
public struct HeadlineCollection: Codable, Sendable {
    /// The headlines in the collection.
    public let headlines: [HeadlineProperties]
    
    enum CodingKeys: String, CodingKey {
        case headlines = "@graph"
    }
}

/// Properties of a headline.
public struct HeadlineProperties: Codable, Sendable {
    /// The URI identifier of the headline.
    public let atId: String
    
    /// The ID of the headline.
    public let id: String
    
    /// The office responsible for the headline.
    public let office: String
    
    /// Whether the headline is marked as important.
    public let important: Bool
    
    /// The issuance time of the headline.
    public let issuanceTime: Date
    
    /// The URL link to the headline.
    public let link: String
    
    /// The name of the headline.
    public let name: String
    
    /// The title of the headline.
    public let title: String
    
    /// The summary of the headline.
    public let summary: String?
    
    /// The content of the headline.
    public let content: String
    
    private enum CodingKeys: String, CodingKey {
        case atId = "@id"
        case id
        case office
        case important
        case issuanceTime
        case link
        case name
        case title
        case summary
        case content
    }
}
