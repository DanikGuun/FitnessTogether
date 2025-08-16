

import XCTest
import FTDomainData
@testable import FitnessTogether

final class WorkoutBuilderExerciseStateTests: XCTestCase {
    
    var state: WorkoutBuilderExerciseState!
    fileprivate var delegate: MockDelegate!
    
    override func setUp() {
        
        state = WorkoutBuilderExerciseState()
        delegate = MockDelegate()
        state.delegate = delegate
        super.setUp()
    }
    
    override func tearDown() {
        state = nil
        delegate = nil
        super.tearDown()
    }
    
    func test_Apply() {
        let exercises: [FTExerciseCreate] = [FTExerciseCreate(name: "ex1")]
        state.exercises = exercises
        var appliedExercises: [FTExerciseCreate] = []
        var empty = FTWorkoutCreate()
        
        state.apply(workoutCreate: &empty, exercises: &appliedExercises)
        
        XCTAssertEqual(appliedExercises, exercises)
    }
    
    func test_AddExercise_RequestToOpenScreen() {
        state.addExerciseButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(delegate.wasAddExerciseCalled)
    }
    
    func test_Finish_RequestGoNext() {
        state.addWorkoutButton.sendActions(for: .touchUpInside)
        
        XCTAssertTrue(delegate.wasGoNextCalled)
    }
    
}

fileprivate class MockDelegate: WorkoutBuilderStateDelegate {
    var wasAddExerciseCalled = false
    var wasGoNextCalled = false
    
    func workoutBuilderStateRequestToAddExercise(_ state: (any WorkoutBuilderState)) {
        wasAddExerciseCalled = true
    }
    
    func screenStateGoNext(_ state: any ScreenState) {
        wasGoNextCalled = true
    }
}
