import Foundation
@testable import KCDragonBall

final class APIClientProtocolMock: APIClientProtocol {
    var didCallRequest = false  // Tracks if the generic request method was called
    var didCallJwt = false  // Tracks if the JWT request method was called
    
    var receivedRequest: URLRequest?  // Stores the URLRequest received by the generic request method
    var receivedJwtRequest: URLRequest?  // Stores the URLRequest received by the JWT request method
    
    var receivedResult: Result<[Hero], NetworkError>?  // Stores the result to return in the generic request
    var receivedJwtResult: Result<String, NetworkError>?  // Stores the result to return in the JWT request
    
    // Simulates the fetching of a JWT token
    func jwt(_ request: URLRequest, completion: @escaping (Result<String, NetworkError>) -> Void) {
        receivedJwtRequest = request  // Save the received request for verification in tests
        didCallJwt = true  // Mark that the JWT request method was called
        
        if let result = receivedJwtResult {
            completion(result)  // Return the mock result for JWT if available
        }
    }
    
    // Simulates a generic network request with a Decodable result
    func request<T: Decodable>(_ request: URLRequest, using: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        receivedRequest = request  // Save the received request for verification in tests
        didCallRequest = true  // Mark that the generic request method was called
        
        // Return the mock result if it's of the expected type
        if let result = receivedResult as? Result<T, NetworkError> {
            completion(result)
        }
    }
}
