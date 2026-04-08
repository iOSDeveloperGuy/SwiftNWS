import Foundation

/// Service for accessing structured SPC outlook geometry layers.
public class SPCOutlooksService {
    private let networkService: NetworkService

    /// Initializes a new SPC outlook service with the specified network service.
    /// - Parameter networkService: The network service to use for API requests.
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    /// Gets the latest geometry for a specific SPC outlook layer.
    /// - Parameter layer: The SPC geometry layer to query.
    /// - Returns: A GeoJSON feature collection for the requested layer.
    /// - Throws: An error if the request fails.
    public func getOutlookGeometry(for layer: NWSSPCOutlookLayer) async throws -> NWSSPCOutlookFeatureCollection {
        let endpoint = SPCOutlookEndpoint.layerQuery(layer: layer)
        return try await networkService.request(endpoint: endpoint, format: .json)
    }
}

internal enum SPCOutlookEndpoint: Endpoint {
    case layerQuery(layer: NWSSPCOutlookLayer)

    var path: String {
        switch self {
        case .layerQuery(let layer):
            return "/vector/rest/services/outlooks/SPC_wx_outlks/MapServer/\(layer.rawValue)/query"
        }
    }

    var baseURLOverride: URL? {
        URL(string: "https://mapservices.weather.noaa.gov")
    }

    var method: HTTPMethod {
        .get
    }

    var queryItems: [URLQueryItem]? {
        [
            URLQueryItem(name: "where", value: "1=1"),
            URLQueryItem(name: "outFields", value: "*"),
            URLQueryItem(name: "f", value: "geojson")
        ]
    }
}
