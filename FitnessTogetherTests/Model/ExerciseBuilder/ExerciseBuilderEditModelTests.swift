

import XCTest
import FTDomainData
@testable import FitnessTogether

final class ExerciseBuilderEditModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: ExerciseBuilderEditModel!
    let workoutId: String = "TestWorkoutId"
    let exerciseId: String = "TestExerciseId"
    
    override func setUp() {
        ftManager = MockFTManager()
        ftManager._workout.workouts = [FTWorkout(id: workoutId)]
        ftManager._exercise.exercises = [FTExercise(id: exerciseId, name: "OldName", workoutId: workoutId)]
        model = ExerciseBuilderEditModel(ftManager: ftManager, workoutId: workoutId, exerciseId: exerciseId)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_GetInitialData() {
        var exercise: FTExerciseCreate!
        
        model.getInitialExerciseData(completion: { ex in exercise = ex })
        
        XCTAssertEqual(exercise.name, "OldName")
    }
    
    func test_SaveExercise() {
        let createData = FTExerciseCreate(name: "TestName")
        
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
