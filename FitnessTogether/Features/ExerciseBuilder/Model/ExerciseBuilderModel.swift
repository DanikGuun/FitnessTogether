
import FTDomainData

public protocol ExerciseBuilderModel {
    var exerciseId: String? { get }
    var workoutId: String { get }
    var addButtonTitle: String { get }
    func saveExercise(_ exercise: FTExerciseCreate, completion: ((Result<Void, Error>) -> ())?)
    func getInitialExerciseData(completion: @escaping ((FTExerciseCreate) -> Void))
}
