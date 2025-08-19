
import FTDomainData

public final class ExerciseBuilderCreateModel: ExerciseBuilderModel {
    
    var ftManager: (any FTManager)
    let workoutId: String
    
    public var mainTitle: String = "Создать упражнения"
    public var addButtonTitle: String = "Добавить"
    
    init(ftManager: (any FTManager), workoutId: String) {
        self.ftManager = ftManager
        self.workoutId = workoutId
    }
    
    public func saveExercise(_ exercise: FTExerciseCreate, completion: ((Result<Void, any Error>) -> ())?) {
        var exercise = exercise
        exercise.workoutId = workoutId
        
        ftManager.exercise.create(data: exercise, completion: { result in
            switch result {
                
            case .success(_):
                completion?(.success(Void()))
                
            case .failure(let error):
                print("ExerciseBuilderCreateModel " + error.localizedDescription)
                completion?(.failure(error))
                
            }
        })
    }
    
    public func getInitialExerciseData(completion: @escaping ((FTExerciseCreate) -> Void)) {
        
    }
    
}
