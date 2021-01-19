import XCTest
import Combine
@testable import VidatecServiceManager

final class VidatecServiceManagerIntegrationTests: XCTestCase {
    
    // MARK: - Integration Tests
    
    func testPeopleIntegrationService() {
        
        // Given
        let service = VidatecService()
        var person: Person?
        var subscriptions = Set<AnyCancellable>()
        let expectation = self.expectation(description: "Waiting for the getPeoples call to complete.")
        
        // When
        service.getPeoples()
            .sink { completion in
                expectation.fulfill()
            } receiveValue: { persons in
                person = persons.first
                debugPrint(persons)
            }.store(in: &subscriptions)
        
        // Then
        waitForExpectations(timeout: 5) { error in
            XCTAssertNil(error)
            XCTAssertEqual(person?.firstName, "Jan")
        }
    }
    
    func testRoomsIntegrationService() {
        
        // Given
        let service = VidatecService()
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

