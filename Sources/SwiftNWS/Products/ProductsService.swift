import Foundation

/// Service for accessing text product-related endpoints of the NWS API.
public class ProductsService {
    /// The product code used by SPC outlook narratives in the NWS API.
    public static let spcOutlookProductCode = "SWO"

    /// The network service used to make API requests.
    private let networkService: NetworkService

    /// Initializes a new products service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    /// Gets text products matching the specified criteria.
    /// - Parameters:
    ///   - locations: Filter by product location identifier.
    ///   - start: Filter by issuance time on or after this value.
    ///   - end: Filter by issuance time on or before this value.
    ///   - offices: Filter by issuing office identifier.
    ///   - wmoCollectiveIds: Filter by WMO collective ID.
    ///   - productTypes: Filter by product code.
    ///   - limit: Limit the number of returned products.
    /// - Returns: A collection of text products.
    /// - Throws: An error if the request fails.
    public func getProducts(
        locations: [String]? = nil,
        start: Date? = nil,
        end: Date? = nil,
        offices: [String]? = nil,
        wmoCollectiveIds: [String]? = nil,
        productTypes: [String]? = nil,
        limit: Int? = nil
    ) async throws -> NWSTextProductCollection {
        let endpoint = ProductsEndpoint.products(
            locations: locations,
            start: start,
            end: end,
            offices: offices,
            wmoCollectiveIds: wmoCollectiveIds,
            productTypes: productTypes,
            limit: limit
        )
        return try await networkService.request(endpoint: endpoint, format: .jsonLD)
    }

    /// Gets all valid text product types and codes.
    /// - Returns: The supported text product types.
    /// - Throws: An error if the request fails.
    public func getProductTypes() async throws -> NWSTextProductTypeCollection {
        let endpoint = ProductsEndpoint.productTypes
        return try await networkService.request(endpoint: endpoint, format: .jsonLD)
    }

    /// Gets text products for the specified product type.
    /// - Parameter typeId: The product code to query.
    /// - Returns: A collection of text products for the type.
    /// - Throws: An error if the request fails.
    public func getProductsForType(_ typeId: String) async throws -> NWSTextProductCollection {
        let endpoint = ProductsEndpoint.productsForType(typeId: typeId)
        return try await networkService.request(endpoint: endpoint, format: .jsonLD)
    }

    /// Gets the valid location identifiers for the specified product type.
    /// - Parameter typeId: The product code to query.
    /// - Returns: The supported location identifiers for the product type.
    /// - Throws: An error if the request fails.
    public func getLocationsForType(_ typeId: String) async throws -> NWSTextProductLocationCollection {
        let endpoint = ProductsEndpoint.locationsForType(typeId: typeId)
        return try await networkService.request(endpoint: endpoint, format: .jsonLD)
    }

    /// Gets the latest text product for the specified type and location.
    /// - Parameters:
    ///   - typeId: The product code to query.
    ///   - locationId: The product location identifier.
    /// - Returns: The latest matching text product, including `productText`.
    /// - Throws: An error if the request fails.
    public func getLatestProduct(typeId: String, locationId: String) async throws -> NWSTextProduct {
        let endpoint = ProductsEndpoint.latestProduct(typeId: typeId, locationId: locationId)
        return try await networkService.request(endpoint: endpoint, format: .jsonLD)
    }

    /// Gets a specific text product by identifier.
    /// - Parameter productId: The product identifier.
    /// - Returns: The matching text product, including `productText`.
    /// - Throws: An error if the request fails.
    public func getProduct(productId: String) async throws -> NWSTextProduct {
        let endpoint = ProductsEndpoint.product(productId: productId)
        return try await networkService.request(endpoint: endpoint, format: .jsonLD)
    }

    /// Gets the latest SPC outlook product for the requested outlook bucket.
    /// - Parameter outlook: The SPC outlook bucket to query.
    /// - Returns: The latest SPC outlook text product.
    /// - Throws: An error if the request fails.
    public func getLatestSPCOutlook(_ outlook: NWSSPCOutlook) async throws -> NWSTextProduct {
        try await getLatestProduct(typeId: Self.spcOutlookProductCode, locationId: outlook.rawValue)
    }
}

/// Endpoints for the products service.
internal enum ProductsEndpoint: Endpoint {
    case products(
        locations: [String]?,
        start: Date?,
        end: Date?,
        offices: [String]?,
        wmoCollectiveIds: [String]?,
        productTypes: [String]?,
        limit: Int?
    )
    case productTypes
    case productsForType(typeId: String)
    case locationsForType(typeId: String)
    case latestProduct(typeId: String, locationId: String)
    case product(productId: String)

    var path: String {
        switch self {
        case .products:
            return "/products"
        case .productTypes:
            return "/products/types"
        case .productsForType(let typeId):
            return "/products/types/\(typeId)"
        case .locationsForType(let typeId):
            return "/products/types/\(typeId)/locations"
        case .latestProduct(let typeId, let locationId):
            return "/products/types/\(typeId)/locations/\(locationId)/latest"
        case .product(let productId):
            return "/products/\(productId)"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .products(let locations, let start, let end, let offices, let wmoCollectiveIds, let productTypes, let limit):
            var items = [URLQueryItem]()

            if let locations, !locations.isEmpty {
                items.append(URLQueryItem(name: "location", value: locations.joined(separator: ",")))
            }

            if let start {
                items.append(URLQueryItem(name: "start", value: start.toISO8601()))
            }

            if let end {
                items.append(URLQueryItem(name: "end", value: end.toISO8601()))
            }

            if let offices, !offices.isEmpty {
                items.append(URLQueryItem(name: "office", value: offices.joined(separator: ",")))
            }

            if let wmoCollectiveIds, !wmoCollectiveIds.isEmpty {
                items.append(URLQueryItem(name: "wmoid", value: wmoCollectiveIds.joined(separator: ",")))
            }

            if let productTypes, !productTypes.isEmpty {
                items.append(URLQueryItem(name: "type", value: productTypes.joined(separator: ",")))
            }

            if let limit {
                items.append(URLQueryItem(name: "limit", value: String(limit)))
            }

            return items.isEmpty ? nil : items
        case .productTypes, .productsForType, .locationsForType, .latestProduct, .product:
            return nil
        }
    }
}
