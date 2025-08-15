
import FTDomainData

public protocol WorkoutBuilderState: ScreenState {
    func apply(to workout: inout FTWorkout)
}

