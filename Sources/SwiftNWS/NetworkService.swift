import Foundation

/// HTTP methods supported by the NWS API.
internal enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

/// Protocol for defining API endpoints.
internal protocol Endpoint {
    /// The path component of the endpoint URL.
    var path: String { get }
    
    /// The HTTP method to use for the request.
    var method: HTTPMethod { get }
    
    /// Query items to include in the request URL.
    var queryItems: [URLQueryItem]? { get }
}

/// Internal service for handling network requests.
internal class NetworkService {
    /// The configuration for the network service.
    let configuration: NWSConfiguration
    
    /// The URL session to use for network requests.
    let session: URLSession
    
    /// Initializes a new network service with the specified configuration.
    /// - Parameter configuration: The configuration to use.
    init(configuration: NWSConfiguration) {
        self.configuration = configuration
        
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = configuration.timeoutInterval
        self.session = URLSession(configuration: config)
    }
    
    /// Makes a request to the specified endpoint and decodes the response to the specified type.
    /// - Parameters:
    ///   - endpoint: The endpoint to request.
    ///   - format: The format to request. If nil, uses the default format from the configuration.
    /// - Returns: The decoded response.
    /// - Throws: An error if the request fails or the response cannot be decoded.
    func request<T: Decodable>(endpoint: Endpoint, format: NWSFormat? = nil) async throws -> T {
        let data = try await request(endpoint: endpoint, format: format)
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NWSError.decodingError(error)
        }
    }
    
    /// Makes a request to the specified endpoint and returns the raw response data.
    /// - Parameters:
    ///   - endpoint: The endpoint to request.
    ///   - format: The format to request. If nil, uses the default format from the configuration.
    /// - Returns: The raw response data.
    /// - Throws: An error if the request fails.
    func request(endpoint: Endpoint, format: NWSFormat? = nil) async throws -> Data {
        guard var components = URLComponents(url: configuration.baseURL, resolvingAgainstBaseURL: true) else {
            throw NWSError.invalidRequest(message: "Invalid base URL")
        }
        
        components.path = endpoint.path
        components.queryItems = endpoint.queryItems
        
        guard let url = components.url else {
            throw NWSError.invalidRequest(message: "Could not construct URL")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Set headers
        request.setValue(configuration.userAgent, forHTTPHeaderField: "User-Agent")
        request.setValue(format?.rawValue ?? configuration.defaultFormat.rawValue, forHTTPHeaderField: "Accept")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NWSError.invalidResponse
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                return data
            case 401:
                throw NWSError.unauthorized
            case 404:
                throw NWSError.notFound
            case 429:
                throw NWSError.rateLimitExceeded
            case 400...499:
                let message = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                throw NWSError.invalidRequest(message: message?["detail"] as? String ?? "Bad request")
            case 500...599:
                throw NWSError.serverError(statusCode: httpResponse.statusCode, message: String(data: data, encoding: .utf8))
            default:
                throw NWSError.unknown(nil)
            }
        } catch let error as NWSError {
            throw error
        } catch {
            throw NWSError.networkError(error)
        }
    }
}
