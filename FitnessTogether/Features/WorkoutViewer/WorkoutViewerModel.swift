
import FTDomainData
import UIKit

public protocol WorkoutViewerModel {
    var workoutId: String { get }
    func getExercises(completion: @escaping ([ExerciseCollectionItem]) -> Void)
    func getCoachName(completion: @escaping (String) -> Void)
    func getWorkoutItem(completion: @escaping (FTWorkout) -> Void )
}

public final class BaseWorkoutViewerModel: WorkoutViewerModel {
    public let workoutId: String
    let ftManager: FTManager
    
    public init(workoutId: String, ftManager: FTManager) {
        self.ftManager = ftManager
        self.workoutId = workoutId
    }
    
    public func getExercises(completion: @escaping ([ExerciseCollectionItem]) -> Void) {
        ftManager.exercise.get(workoutId: workoutId, completion: { result in
            switch result {
                
            case .success(let exercises):
                let items = exercises.map { ExerciseCollectionItem(id: $0.id, title: $0.name, subtitle: $0.description, image: nil) }
                completion(items)
                
            case .failure(let error):
                print("BaseWorkoutViewerModel" + error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func getCoachName(completion: @escaping (String) -> Void) {
        ftManager.workout.get(workoutId: workoutId, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let workout):
                let id = getCoachId(workout: workout)
                getName(id: id, completion: completion)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    private func getCoachId(workout: FTWorkout) -> String {
        guard let coachPart = workout.participants?.first(where: { $0.role == .coach }) else { return "" }
        return coachPart.userId
        
    }
    
    private func getName(id: String, completion: @escaping (String) -> Void) {
        ftManager.user.get(id: id, completion: { result in
            switch result {
                
            case .success(let coach):
                completion(coach.firstName + coach.lastName)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func getWorkoutItem(completion: @escaping (FTWorkout) -> Void) {
        ftManager.workout.get(workoutId: workoutId, completion: { result in
            switch result {
                
            case .success(let workout):
                completion(workout)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
}
