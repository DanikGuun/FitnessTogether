

import XCTest
import FTDomainData
@testable import FitnessTogether

final class WorkoutBuilderMetaStateTests: XCTestCase {
    
    var state: WorkoutBuilderMetaState!
    
    override func setUp() {
        state = WorkoutBuilderMetaState(clientsProvider: EmptyClientProvider())
        super.setUp()
    }
    
    override func tearDown() {
        state = nil
        super.tearDown()
    }
    
    func test_apply() {
        var workout = FTWorkoutCreate()
        let type = FTWorkoutKind.cardio
        let description = "Test"
        var startDate = Date().addingTimeInterval(-1000)
        let difInterval = startDate.timeIntervalSince1970.truncatingRemainder(dividingBy: 300)
        startDate = startDate.addingTimeInterval(-difInterval)
        let client = FTUser(firstName: "UserClient", id: "ClientID")
        let clientItem = ClientListItem(id: client.id)
        var exercieses = [FTExerciseCreate]()
        
        state.workoutKindSelecter.selectedWorkoutKind = type
        state.descriptionTextView.text = description
        state.dateTimeView.date = startDate
        state.clientSelecter.items = [clientItem]
        state.clientSelecter.selectedItem = clientItem
        state.apply(workoutCreate: &workout, exercises: &exercieses)
        
        XCTAssertEqual(workout.workoutKind, type)
        XCTAssertEqual(workout.description, description)
        XCTAssertEqual(workout.startDate, startDate.ISO8601Format())
    }
    
    func test_NextButton_Enable() {
        state.dateTimeView.date = Date()
        state.clientSelecter.items = [ClientListItem(id: "Test")]
        state.clientSelecter.selectClient(id: "Test")
        
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
}

fileprivate class EmptyClientProvider: ClientProvider {
    func getClients(completion: @escaping (([FTUser]) -> Void)) {
        
    }
}
