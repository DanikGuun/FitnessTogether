
import FTDomainData

public protocol ExerciseBuilderModel {
    var mainTitle: String { get }
    var addButtonTitle: String { get }
    func saveExercise(_ exercise: FTExerciseCreate, completion: ((Result<Void, Error>) -> ())?)
    func getInitialExerciseData(completion: @escaping ((FTExerciseCreate) -> Void))
}
