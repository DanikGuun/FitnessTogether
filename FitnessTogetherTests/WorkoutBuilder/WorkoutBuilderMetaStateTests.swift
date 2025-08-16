

import XCTest
import FTDomainData
@testable import FitnessTogether

final class WorkoutBuilderMetaStateTests: XCTestCase {
    
    var state: WorkoutBuilderMetaState!
    
    override func setUp() {
        state = WorkoutBuilderMetaState()
        super.setUp()
    }
    
    override func tearDown() {
        state = nil
        super.tearDown()
    }
    
    func test_apply() {
        var workout = FTWorkout()
        let type = FTWorkoutKind.cardio
        let description = "Test"
        var startDate = Date().addingTimeInterval(-1000)
        let difInterval = startDate.timeIntervalSince1970.truncatingRemainder(dividingBy: 300)
        startDate = startDate.addingTimeInterval(-difInterval)
        let client = FTUser(firstName: "UserClient", id: "ClientID")
        let clientItem = ClientListItem(id: client.id)
        
        state.workoutKindSelecter.selectedWorkoutKind = type
        state.descriptionTextView.text = description
        state.dateTimeView.date = startDate
        state.clientSelecter.items = [clientItem]
        state.clientSelecter.selectedItem = clientItem
        state.apply(to: &workout)
        
        XCTAssertEqual(workout.workoutKind, type)
        XCTAssertEqual(workout.description, description)
        XCTAssertEqual(workout.startDate, startDate)
        XCTAssertEqual(workout.participants.first!.userId, client.id)
    }
    
    func test_NextButton_Enable() {
        state.dateTimeView.date = Date()
        state.clientSelecter.items = [ClientListItem(id: "Test")]
        state.clientSelecter.selectClient(id: "Test")
        
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
}
