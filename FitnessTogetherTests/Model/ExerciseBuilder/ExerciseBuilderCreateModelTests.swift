

import XCTest
import FTDomainData
@testable import FitnessTogether

final class ExerciseBuilderCreateModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: ExerciseBuilderCreateModel!
    let workoutId: String = "TestWorkoutId"
    
    override func setUp() {
        ftManager = MockFTManager()
        ftManager._workout.workouts = [FTWorkout(id: workoutId)]
        model = ExerciseBuilderCreateModel(ftManager: ftManager, workoutId: workoutId)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_GetInitialData() {
        var wasExecuted = false
        model.getInitialExerciseData(completion: { _ in wasExecuted = true })
        XCTAssertFalse(wasExecuted)
    }
    
    func test_SaveExercise() {
        let createData = FTExerciseCreate(name: "TestName", workoutId: workoutId)
        
        model.saveExercise(createData, completion: nil)
        var exercise: FTExercise!
        ftManager.exercise.get(workoutId: workoutId, completion: { result in
            switch result {
            case .success(let exercises):
                exercise = exercises.first!
                
            case .failure(let error):
                return
            }
        })
        
        XCTAssertEqual(exercise.name, createData.name)
    }
    
}
