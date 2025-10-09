
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
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func getClients(completion: @escaping (([FTClientData]) -> Void)) {
        ftManager.user.getClients(completion: { result in
            switch result {
                
            case .success(let users):
                completion(users)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func getInitialWorkoutData(completion: ((FTWorkoutCreate?) -> Void)) { }
    
}
