

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
    
    func test_SaveWorkoutAndExercises() {
        let workout = FTWorkoutCreate(description: "Test")
        let exercise = FTExerciseCreate(name: "Test")
        let user = FTUser(id: "TestUserId")
        
        ftManager._user.user = user
        model.workout = workout
        model.exercises = [exercise]
        model.saveWorkoutAndExercises(completion: nil)
        
        let savedWorkout = ftManager._workout.workouts.first
        let savedExercise = ftManager._exercise.exercises.first
        XCTAssertNotNil(savedWorkout)
        XCTAssertNotNil(savedExercise)
        XCTAssertEqual(savedWorkout?.participants.first?.userId, user.id)
        XCTAssertEqual(savedExercise?.workoutId, savedWorkout?.id)
    }
    
}
