import Foundation

/// Models for text product-related API responses.

/// A text product returned by the NWS API.
public struct NWSTextProduct: Codable, Sendable {
    /// The URI identifier of the product.
    public let atId: URL?

    /// The product identifier.
    public let id: String

    /// The WMO collective ID for the product.
    public let wmoCollectiveId: String?

    /// The issuing office identifier.
    public let issuingOffice: String

    /// The issuance time of the product.
    public let issuanceTime: Date

    /// The product code.
    public let productCode: String

    /// The product name.
    public let productName: String

    /// The full text of the product.
    public let productText: String?

    private enum CodingKeys: String, CodingKey {
        case atId = "@id"
        case id
        case wmoCollectiveId
        case issuingOffice
        case issuanceTime
        case productCode
        case productName
        case productText
    }
}

/// A collection of text products.
public struct NWSTextProductCollection: Codable, Sendable {
    /// The products in the collection.
    public let products: [NWSTextProduct]

    private enum CodingKeys: String, CodingKey {
        case products = "@graph"
    }
}

/// A text product type returned by the NWS API.
public struct NWSTextProductType: Codable, Sendable {
    /// The product code.
    public let productCode: String

    /// The product name.
    public let productName: String
}

/// A collection of text product types.
public struct NWSTextProductTypeCollection: Codable, Sendable {
    /// The product types in the collection.
    public let productTypes: [NWSTextProductType]

    private enum CodingKeys: String, CodingKey {
        case productTypes = "@graph"
    }
}

/// A collection of product locations keyed by location identifier.
public struct NWSTextProductLocationCollection: Decodable, Sendable {
    /// The location identifiers supported for a given product type.
    public let locations: [String]

    private enum CodingKeys: String, CodingKey {
        case rawLocations = "locations"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let rawLocations = try container.decode([String: String?].self, forKey: .rawLocations)
        self.locations = rawLocations.keys.sorted()
    }
}

/// SPC outlook products exposed through the NWS text products API.
public enum NWSSPCOutlook: String, Codable, Sendable {
    case day1 = "DY1"
    case day2 = "DY2"
    case day3 = "DY3"
    case day4To8 = "D48"
    case mesoscaleDiscussion = "MCD"
}
