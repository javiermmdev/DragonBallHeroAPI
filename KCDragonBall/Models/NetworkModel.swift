import Foundation

final class NetworkModel {
    static let shared = NetworkModel()
    
    var token: String?
    
    private let client: APIClientProtocol
    
    // UserDefaults Keys
    private let authTokenKey = "authToken"
    private let userKey = "user"
    private let passwordKey = "password"
    
    // Base Components for the API URL
    private let scheme = "https"
    private let host = "dragonball.keepcoding.education"
    
    // Initializer with an optional APIClientProtocol (defaults to APIClient)
    init(client: APIClientProtocol = APIClient()) {
        self.client = client
    }
    
    // MARK: - Base Components
    // Constructs base URL components with scheme and host
    private var baseComponents: URLComponents {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        return components
    }

    // MARK: - Login Function
    func login(user: String, password: String, completion: @escaping (Bool) -> Void) {
        var components = baseComponents
        components.path = "/api/auth/login"
        
        // Ensure the URL is valid
        guard let url = components.url else {
            completion(false)
            return
        }
        
        // Prepare the login string and encode it to base64
        let loginString = String(format: "%@:%@", user, password)
        guard let loginData = loginString.data(using: .utf8) else {
            completion(false)
            return
        }
        
        let base64LoginString = loginData.base64EncodedString()
        
        // Setup the request with Authorization header
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // Call the client to obtain the JWT token
        client.jwt(request) { [weak self] result in
            switch result {
                case let .success(token):
                    self?.token = token
                    self?.saveLoginDetails(user: user, password: password, token: token)
                    completion(true)
                case .failure:
                    completion(false)
            }
        }
    }

    // MARK: - Validate Token
    // Validates the token by attempting a login with stored credentials
    func validateToken(completion: @escaping (Bool) -> Void) {
        guard let user = getUser(), let password = getPassword() else {
            completion(false)
            return
        }
        
        login(user: user, password: password) { success in
            completion(success)
        }
    }

    // MARK: - Save and Retrieve Login Details
    // Stores login details in UserDefaults
    private func saveLoginDetails(user: String, password: String, token: String) {
        UserDefaults.standard.set(token, forKey: authTokenKey)
        UserDefaults.standard.set(user, forKey: userKey)
        UserDefaults.standard.set(password, forKey: passwordKey)
    }
    
    // Retrieves the saved JWT token from UserDefaults
    func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: authTokenKey)
    }
    
    // Retrieves the saved username from UserDefaults
    func getUser() -> String? {
        return UserDefaults.standard.string(forKey: userKey)
    }
    
    // Retrieves the saved password from UserDefaults
    func getPassword() -> String? {
        return UserDefaults.standard.string(forKey: passwordKey)
    }

    // MARK: - Logout
    // Clears saved login details and token
    func logout() {
        UserDefaults.standard.removeObject(forKey: authTokenKey)
        UserDefaults.standard.removeObject(forKey: userKey)
        UserDefaults.standard.removeObject(forKey: passwordKey)
        self.token = nil
    }
    
    // MARK: - Fetch Heroes
    func getHeroes(completion: @escaping (Result<[Hero], NetworkError>) -> Void) {
        var components = baseComponents
        components.path = "/api/heros/all"
        
        // Ensure the URL is valid
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // Prepare the request body and token
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["name": ""]),
              let token = token else {
            completion(.failure(.unknown))
            return
        }
        
        // Setup the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = serializedBody
        
        // Call the client to fetch heroes
        client.request(request, using: [Hero].self, completion: completion)
    }

    // MARK: - Fetch Transformations
    func getTransformations(for hero: Hero, completion: @escaping (Result<[Transformation], NetworkError>) -> Void) {
        var components = baseComponents
        components.path = "/api/heros/tranformations"
        
        // Ensure the URL is valid
        guard let url = components.url else {
            completion(.failure(.malformedURL))
            return
        }
        
        // Prepare the request body and token
        guard let serializedBody = try? JSONSerialization.data(withJSONObject: ["id": hero.id]),
              let token = token else {
            completion(.failure(.unknown))
            return
        }
        
        // Setup the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = serializedBody
        
        // Call the client to fetch transformations
        client.request(request, using: [Transformation].self, completion: completion)
    }
}
