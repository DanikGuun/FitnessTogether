
import Foundation
import FTDomainData

public final class EditWorkoutBuilderModel: WorkoutBuilderModel {
    
    let ftManager: any FTManager
    public let workoutId: String?
    public var mainTitle: String = "Изменить тренировку"
    public var addButtonTitle: String = "Сохранить"
    
    init(ftManager: any FTManager, workoutId: String){
        self.ftManager = ftManager
        self.workoutId = workoutId
    }
    
    //MARK: - Start Data
    public func saveWorkout(workout: FTWorkoutCreate, completion: ((Result<FTWorkout, any Error>) -> (Void))?) {
        ftManager.workout.edit(workoutId: workoutId!, newData: workout, completion: { result in
            switch result {
                
            case .success(let workout):
                completion?(.success(workout))
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.failure(error))
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
            }
        })
    }
    
    public func getInitialWorkoutData(completion: @escaping ((FTWorkoutCreate?) -> Void)) {
        ftManager.workout.get(workoutId: workoutId!, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let workout):
                let workoutData = FTWorkoutCreate(description: workout.description,
                                                  startDate: workout.startDate ?? Date(),
                                                  userId: getClientId(workout: workout),
                                                  workoutKind: workout.workoutKind)
                completion(workoutData)
                
            case .failure(let error):
                print("EditWorkoutBuilderModel " + error.localizedDescription)
            }
        })
    }
    
    private func getClientId(workout: FTWorkout) -> String {
        guard let part = workout.participants?.first(where: { $0.role == .client }) else { return "" }
        return part.userId
    }
}
