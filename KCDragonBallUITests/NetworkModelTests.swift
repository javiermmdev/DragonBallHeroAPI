import XCTest
@testable import KCDragonBall

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModel!
    private var mock: APIClientProtocolMock!
    
    override func setUp() {
        super.setUp()
        // Initialize the mock and system under test (sut)
        mock = APIClientProtocolMock()
        sut = NetworkModel(client: mock)
    }
    
    // MARK: - Login Success Test
    func test_login_success() {
        // Given
        let someJwt = "some_jwt_token"
        mock.receivedJwtResult = .success(someJwt)
        var loginResult = false
        
        // URL and request setup for the login endpoint
        let expectedURL = URL(string: "https://dragonball.keepcoding.education/api/auth/login")!
        var expectedRequest = URLRequest(url: expectedURL)
        expectedRequest.httpMethod = "POST"
        let loginString = String(format: "%@:%@", "testUser", "testPassword")
        let loginData = loginString.data(using: .utf8)!
        let base64LoginString = loginData.base64EncodedString()
        expectedRequest.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        // When
        sut.login(user: "testUser", password: "testPassword") { success in
            loginResult = success
        }
        
        // Then
        XCTAssertTrue(loginResult)  // Verify the login was successful
        XCTAssertTrue(mock.didCallJwt)  // Verify the JWT method was called
        XCTAssertEqual(mock.receivedJwtRequest, expectedRequest)  // Ensure the request was as expected
    }
    
    // MARK: - Login Failure Test
    func test_login_failure() {
        // Given
        mock.receivedJwtResult = .failure(.unknown)
        var loginResult = true  // Initially set to true to verify it changes to false
        
        // When
        sut.login(user: "testUser", password: "testPassword") { success in
            loginResult = success
        }
        
        // Then
        XCTAssertFalse(loginResult)  // Verify the login failed
        XCTAssertTrue(mock.didCallJwt)  // Verify the JWT method was called
    }
    
    // MARK: - Get Heroes Success Test
    func test_getHeroes_success() {
        // Given
        let someHeroes: [Hero] = []
        mock.receivedResult = .success(someHeroes)
        var receivedResult: Result<[Hero], NetworkError>?
        
        // URL and request setup for the getHeroes endpoint
        let expectedURL = URL(string: "https://dragonball.keepcoding.education/api/heros/all")!
        var expectedRequest = URLRequest(url: expectedURL)
        expectedRequest.httpMethod = "POST"
        expectedRequest.setValue("Bearer some_token", forHTTPHeaderField: "Authorization")
        expectedRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        sut.token = "some_token"  // Simulate having a valid token
        
        // When
        sut.getHeroes { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(receivedResult, .success(someHeroes))  // Verify the result is successful
        XCTAssertTrue(mock.didCallRequest)  // Verify the request was made
        XCTAssertEqual(mock.receivedRequest, expectedRequest)  // Ensure the request matches the expected one
    }
    
    // MARK: - Get Heroes Failure Test
    func test_getHeroes_failure() {
        // Given
        mock.receivedResult = .failure(.unknown)
        var receivedResult: Result<[Hero], NetworkError>?
        
        sut.token = "some_token"  // Simulate having a valid token
        
        // When
        sut.getHeroes { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(receivedResult, .failure(.unknown))  // Verify the response was a failure
        XCTAssertTrue(mock.didCallRequest)  // Verify the request was made
    }
}
