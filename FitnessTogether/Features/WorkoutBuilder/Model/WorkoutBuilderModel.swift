
import FTDomainData

public protocol WorkoutBuilderModel {
    var mainTitle: String { get }
    var addButtonTitle: String { get }
    var workoutId: String? { get }
    func saveWorkout(workout: FTWorkoutCreate, completion: ((Result<FTWorkout, Error>) -> (Void))?)
    func getClients(completion: @escaping (([FTUser]) -> Void))
    func getInitialWorkoutData(completion: @escaping ((FTWorkoutCreate?) -> Void))
}
