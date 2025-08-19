import FTDomainData

public final class ExerciseBuilderEditModel: ExerciseBuilderModel {
    
    var ftManager: (any FTManager)
    let exerciseId: String
    
    init(ftManager: (any FTManager), exerciseId: String) {
        self.ftManager = ftManager
        self.exerciseId = exerciseId
    }
    
    public func saveExercise(_ exercise: FTExerciseCreate, completion: ((Result<Void, any Error>) -> ())?) {
        var exercise = exercise
        
        ftManager.exercise.update(exerciseId: exerciseId, data: exercise, completion: { result in
            switch result {
                
            case .success(_):
                completion?(.success(Void()))
                
            case .failure(let error):
                print("ExerciseBuilderCreateModel " + error.localizedDescription)
                completion?(.failure(error))
                
            }
        })
    }
    
}
