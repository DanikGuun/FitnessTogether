
import FTDomainData

public final class CreateWorkoutBuilderModel: WorkoutBuilderModel {
    
    var ftManager: FTManager!
    public private(set) var workoutId: String?
    public var mainTitle: String = "Создать тренировку"
    public var addButtonTitle: String = "Сохранить"
    
    init(ftManager: FTManager!) {
        self.ftManager = ftManager
    }
    
    public func saveWorkout(workout: FTWorkoutCreate, completion: ((Result<FTWorkout, any Error>) -> (Void))?) {
        ftManager.workout.create(data: workout, completion: { [weak self] result in
            switch result {
                
            case .success(let workout):
                self?.workoutId = workout.id
                completion?(.success(workout))
                
            case .failure(let error):
                print("CreateWorkoutBuilderModel " + error.localizedDescription)
                completion?(.failure(error))
            }
        })
    }
    
    public func getClients(completion: @escaping (([FTUser]) -> Void)) {
        ftManager.user.getClients(completion: { result in
            switch result {
                
            case .success(let users):
                completion(users)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    public func getInitialWorkoutData(completion: ((FTWorkoutCreate?) -> Void)) { }
    
//    private func addExercises(resultCompletion: ((Result<Void, Error>) -> (Void))?, completion: @escaping (Result<Void, Error>) -> (Void)) {
//        var count = 0
//        for exercise in exercises {
//            ftmanager.exercise.create(data: exercise, completion: { result in
//                switch result {
//                case .success(let exercise):
//                    count += 1
//                    if count == self.exercises.count {
//                        completion(.success(()))
//                    }
//                    
//                case .failure(let error):
//                    resultCompletion?(.failure(error))
//                    return
//                }
//            })
//        }
//    }
    
}
