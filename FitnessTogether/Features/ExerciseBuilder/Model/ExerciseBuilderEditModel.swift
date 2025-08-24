import FTDomainData

public final class ExerciseBuilderEditModel: ExerciseBuilderModel {
    
    var ftManager: (any FTManager)
    public let workoutId: String
    public var exerciseId: String?
    
    public var mainTitle: String = "Изменить упражнение"
    public var addButtonTitle: String = "Сохранить"
    
    init(ftManager: (any FTManager), workoutId: String, exerciseId: String) {
        self.ftManager = ftManager
        self.workoutId = workoutId
        self.exerciseId = exerciseId
    }
    
    public func saveExercise(_ exercise: FTExerciseCreate, completion: ((Result<Void, any Error>) -> ())?) {
        var exercise = exercise
        exercise.workoutId = workoutId
        
        ftManager.exercise.update(exerciseId: exerciseId!, data: exercise, completion: { result in
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
        ftManager.exercise.get(exerciseId: exerciseId!, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let exercise):
                let data = exerciseToCreate(exercise)
                completion(data)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func exerciseToCreate(_ exercise: FTExercise) -> FTExerciseCreate {
        let exerciseCreate = FTExerciseCreate(
            name: exercise.name,
            description: exercise.name,
            muscleKinds: exercise.muscleKinds,
            complexity: exercise.сomplexity,
            workoutId: exercise.workoutId
        )
        return exerciseCreate
    }
    
}
