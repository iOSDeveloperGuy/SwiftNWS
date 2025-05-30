import Foundation

/// Errors that can occur when interacting with the NWS API.
public enum NWSError: Error {
    /// An error occurred with the network request.
    case networkError(Error)
    
    /// The response from the server was invalid.
    case invalidResponse
    
    /// An error occurred while decoding the response.
    case decodingError(Error)
    
    /// The rate limit for the API has been exceeded.
    case rateLimitExceeded
    
    /// The server returned an error.
    case serverError(statusCode: Int, message: String?)
    
    /// The request was invalid.
    case invalidRequest(message: String)
    
    /// The request was unauthorized.
    case unauthorized
    
    /// The requested resource was not found.
    case notFound
    
    /// An unknown error occurred.
    case unknown(Error?)
    
    /// A human-readable description of the error.
    public var localizedDescription: String {
        switch self {
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError(let error):
            return "Error decoding response: \(error.localizedDescription)"
        case .rateLimitExceeded:
            return "API rate limit exceeded. Please try again later."
        case .serverError(let statusCode, let message):
            if let message = message {
                return "Server error (\(statusCode)): \(message)"
            } else {
                return "Server error (\(statusCode))"
            }
        case .invalidRequest(let message):
            return "Invalid request: \(message)"
        case .unauthorized:
            return "Unauthorized request"
        case .notFound:
            return "Resource not found"
        case .unknown(let error):
            if let error = error {
                return "Unknown error: \(error.localizedDescription)"
            } else {
                return "Unknown error occurred"
            }
        }
    }
}
