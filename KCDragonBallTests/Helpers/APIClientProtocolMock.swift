import Foundation
@testable import KCDragonBall

final class APIClientProtocolMock<C: Codable>: APIClientProtocol {
    var session: URLSession = .shared
    
    var didCallRequest = false
    var receivedRequest: URLRequest?

    var receivedResult: Result<C, NetworkError>?
    func request<T: Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        receivedRequest = request
        didCallRequest = true
        
        if let result = receivedResult as? Result<T, NetworkError> {
            completion(result)
        }
    }
    
    var didCallJWT = false
    var receivedTokenRequest: URLRequest?
    var receivedTokenResult: Result<String, NetworkError>?
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        didCallJWT = true
        receivedTokenRequest = request
        if let receivedTokenResult {
            completion(receivedTokenResult)
        }
    }
}
