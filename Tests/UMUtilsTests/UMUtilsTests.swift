import XCTest
import Combine
import Request
@testable import UMUtils

final class UMUtilsTests: XCTestCase {
    var cancellations: [AnyCancellable] = []

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let expectation = XCTestExpectation(description: "Download apple.com home page")

        print("Result", "Started")

        Request {
            Url("https://apihom.mercadoonbrasil.com.br/api/v1/settings")
            Method(.get)
            Header.ContentType(.json)
        }
        .apiPublisher(APIObject<Config>.self)
        .retryOnConnected(maxOfRetries: 30)
        .sink {
            print("Result", $0)
            if case .success = $0 {
                expectation.fulfill()
            }
        }
        .store(in: &self.cancellations)

        wait(for: [expectation], timeout: 50)
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}

struct Config: Decodable {

}
