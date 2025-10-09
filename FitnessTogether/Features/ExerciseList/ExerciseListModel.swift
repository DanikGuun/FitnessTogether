
import FTDomainData

public protocol ExerciseListModel {
    var workoutId: String { get }
    func getExercises(completion: @escaping ([FTExercise]) -> Void)
}

public final class BaseExerciseModel: ExerciseListModel {
    
    var ftManager: (any FTManager)
    public let workoutId: String
    
    init(ftManager: any FTManager, workoutId: String) {
        self.ftManager = ftManager
        self.workoutId = workoutId
    }
    
    public func getExercises(completion: @escaping ([FTExercise]) -> Void) {
        ftManager.exercise.get(workoutId: workoutId, completion: { result in
            switch result {
                
            case .success(let exercises):
                completion(exercises)
                
            case .failure(let error):
                print("BaseExerciseModel " + error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
}
