import Foundation

enum NetworkError: Error, Equatable {
    case malformedURL
    case noData
    case statusCode(code: Int?)
    case decodingFailed
    case unknown
}

protocol APIClientProtocol {
    // Method to fetch a JWT token using a URL request
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    )
    
    // Generic method to make a network request and decode the response into a specified type
    func request<T: Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    )
}

struct APIClient: APIClientProtocol {
    let session: URLSession
    
    // Initializer with a default shared URLSession instance
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - JWT Fetching
    func jwt(
        _ request: URLRequest,
        completion: @escaping (Result<String, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<String, NetworkError>
            
            defer {
                // Ensure the result is returned after all processing
                completion(result)
            }
            
            // Check for errors in the network request
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            // Ensure that data is returned
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            // Check the status code of the response
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }
            
            // Attempt to convert the data to a string (JWT token)
            guard let token = String(data: data, encoding: .utf8) else {
                result = .failure(.decodingFailed)
                return
            }
            
            // Return the token if successful
            result = .success(token)
        }
        
        task.resume()  // Start the network request
    }
    
    // MARK: - Generic Request Method
    func request<T: Decodable>(
        _ request: URLRequest,
        using: T.Type,
        completion: @escaping (Result<T, NetworkError>) -> Void
    ) {
        let task = session.dataTask(with: request) { data, response, error in
            let result: Result<T, NetworkError>
            
            defer {
                // Ensure the result is returned after all processing
                completion(result)
            }
            
            // Check for errors in the network request
            guard error == nil else {
                result = .failure(.unknown)
                return
            }
            
            // Ensure that data is returned
            guard let data else {
                result = .failure(.noData)
                return
            }
            
            // Check the status code of the response
            let statusCode = (response as? HTTPURLResponse)?.statusCode
            guard statusCode == 200 else {
                result = .failure(.statusCode(code: statusCode))
                return
            }
            
            // Attempt to decode the response data into the expected model type
            guard let model = try? JSONDecoder().decode(using, from: data) else {
                result = .failure(.decodingFailed)
                return
            }
            
            // Return the decoded model if successful
            result = .success(model)
        }
        
        task.resume()  // Start the network request
    }
}
