
import FTDomainData

public protocol WorkoutBuilderState: ScreenState {
    func apply(workoutCreate workout: inout FTWorkoutCreate, exercises: inout [FTExerciseCreate])
}

public protocol WorkoutBuilderStateDelegate: ScreenStateDelegate {
    func workoutBuilderStateRequestToAddExercise(_ state: (any WorkoutBuilderState))
}
