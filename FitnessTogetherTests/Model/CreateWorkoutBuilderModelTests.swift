

import XCTest
import FTDomainData
@testable import FitnessTogether

final class CreateWorkoutBuilderModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: CreateWorkoutBuilderModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = CreateWorkoutBuilderModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_StartData() {
        XCTAssertEqual(model.currentState, -1)
    }
    
    func test_GetNextState_Correct() {
        let state = model.getNextState()
        XCTAssertNotNil(state)
        XCTAssertEqual(model.currentState, 0)
    }
    
    func test_GetNextState_OutOfBounds() {
        var state = model.getNextState()
        state = model.getNextState()
        state = model.getNextState()
        XCTAssertNil(state)
        XCTAssertEqual(model.currentState, 1)
    }
    
    func test_GetPreviousState_Correct() {
        var state = model.getNextState()
        state = model.getNextState()
        state = model.getPreviousState()
        XCTAssertNotNil(state)
        XCTAssertEqual(model.currentState, 0)
    }
    
    func test_GetPreviousState_OutOfBounds() {
        let _ = model.getNextState()
        XCTAssertNil(model.getPreviousState())
        XCTAssertEqual(model.currentState, 0)
    }
    
    func test_ApplyingState() {
        let _ = model.getNextState()
        let state = model.getNextState() as? WorkoutBuilderExerciseState
        XCTAssertNotNil(state)
        let exercise = FTExerciseCreate(name: "title1")
        state?.exercises = [exercise]
        
        model.applyDataIfNeeded()
        let modelExercise = model.exercises.first
        
        XCTAssertEqual(modelExercise, exercise)
    }
    
}
