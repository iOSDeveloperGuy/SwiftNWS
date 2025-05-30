import Foundation

/// Models for office-related API responses.

/// An office from the NWS API.
public struct Office: Codable {
    /// The ID of the office.
    public let id: String
    
    /// The properties of the office.
    public let properties: OfficeProperties
}

/// A collection of offices.
public struct OfficeCollection: Codable {
    /// The offices in the collection.
    public let features: [Office]
    
    /// Pagination information for the collection.
    public let pagination: Pagination?
}

/// Properties of an office.
public struct OfficeProperties: Codable {
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
public struct OfficeAddress: Codable {
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
public struct Headline: Codable {
    /// The ID of the headline.
    public let id: String
    
    /// The properties of the headline.
    public let properties: HeadlineProperties
}

/// A collection of headlines.
public struct HeadlineCollection: Codable {
    /// The headlines in the collection.
    public let features: [Headline]
    
    /// Pagination information for the collection.
    public let pagination: Pagination?
}

/// Properties of a headline.
public struct HeadlineProperties: Codable {
    /// The ID of the headline.
    public let id: String
    
    /// The title of the headline.
    public let title: String
    
    /// The content of the headline.
    public let content: String
    
    /// The date the headline was published.
    public let published: Date
    
    /// The date the headline was updated.
    public let updated: Date?
    
    /// The URL of the headline.
    public let url: URL?
}
