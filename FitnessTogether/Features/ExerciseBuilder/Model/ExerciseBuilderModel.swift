
import FTDomainData

public protocol ExerciseBuilderModel {
    func saveExercise(_ exercise: FTExerciseCreate, completion: ((Result<Void, Error>) -> ())?)
}
