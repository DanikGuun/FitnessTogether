
import FTDomainData

public protocol WorkoutBuilderModel {
    func saveWorkout(workout: FTWorkoutCreate, completion: ((Result<FTWorkout, Error>) -> (Void))?)
    func getClients(completion: @escaping (([FTUser]) -> Void))
    func getInitialWorkoutData(completion: @escaping ((FTWorkoutCreate?) -> Void))
}
