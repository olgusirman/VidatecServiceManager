import XCTest
import Combine
@testable import VidatecServiceManager

final class VidatecServiceManagerTests: XCTestCase {
    
    // MARK: - Sample tests
    func testExample() {
        XCTAssertEqual(VidatecServiceManager().text, "Hello, World!")
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
    
    // MARK: - Unit Tests
    
    func testPeopleMockService() {
        
        // Given
        let service = VidatecMockService()
        var person: Person?
        var subscriptions = Set<AnyCancellable>()
        let expectation = self.expectation(description: "Waiting for the getPeoples call to complete.")
        
        // When
        service.getPeoples()
            .sink { completion in
                expectation.fulfill()
            } receiveValue: { persons in
                person = persons.first
            }.store(in: &subscriptions)
        
        // Then
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
            XCTAssertEqual(person?.firstName, "Jan")
        }
    }
    
    func testRoomsMockService() {
        
        // Given
        let service = VidatecMockService()
        var firstRoom: Room?
        var subscriptions = Set<AnyCancellable>()
        let expectation = self.expectation(description: "Waiting for the getPeoples call to complete.")
        
        // When
        service.getRooms()
            .sink { completion in
                expectation.fulfill()
            } receiveValue: { rooms in
                firstRoom = rooms.first
            }.store(in: &subscriptions)
        
        // Then
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
            XCTAssertEqual(firstRoom?.name, "pixel")
        }
    }
}
