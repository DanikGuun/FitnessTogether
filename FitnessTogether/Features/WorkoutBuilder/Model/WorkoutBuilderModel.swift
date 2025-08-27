
import FTDomainData

public protocol WorkoutBuilderModel {
    var workoutId: String? { get }
    func saveWorkout(workout: FTWorkoutCreate, completion: ((Result<FTWorkout, Error>) -> (Void))?)
    func getClients(completion: @escaping (([FTClientData]) -> Void))
    func getInitialWorkoutData(completion: @escaping ((FTWorkoutCreate?) -> Void))
}
