import XCTest
@testable import KCDragonBall

final class NetworkModelTests: XCTestCase {
    private var sut: NetworkModel!
    private var client: APIClientProtocolMock<[Hero]>!
    
    override func setUp() {
        super.setUp()
        client = APIClientProtocolMock()
        sut = NetworkModel(client: client)
    }
    
    override func tearDown() {
        super.tearDown()
        client = nil
        sut = nil
    }
    
    func test_getHeros_success() {
        // Given
        let someResult = Result<[Hero], NetworkError>.success([])
        client.receivedResult = someResult
        var receivedResult: Result<[Hero], NetworkError>?
        let expectedURL = URL(string: "https://dragonball.keepcoding.education/api/heros/all")!
        var expectedRequest = URLRequest(url: expectedURL)
        expectedRequest.httpMethod = "POST"

        // When
        sut.getHeroes { result in
            receivedResult = result
        }

        // Then
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(client.didCallRequest)
        XCTAssertEqual(client.receivedRequest?.url, expectedRequest.url)
    }
    
    func test_getHeros_failure() {
        // Given
        let someResult = Result<[Hero], NetworkError>.failure(.unknown)
        client.receivedResult = someResult
        var receivedResult: Result<[Hero], NetworkError>?

        // When
        sut.getHeroes { result in
            receivedResult = result
        }
        
        // Then
        XCTAssertEqual(someResult, receivedResult)
        XCTAssert(client.didCallRequest)
    }
}
