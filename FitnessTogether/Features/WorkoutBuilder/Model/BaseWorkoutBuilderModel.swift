
public final class BaseWorkoutBuilderModel: WorkoutBuilderModel {
    
    public private(set) var currentState = -1
    let states: [any ScreenState]
    
    init() {
        states = [
            WorkoutBuilderMetaState(),
            WorkoutBuilderExerciseState()
        ]
    }
    
    public func getNextState() -> (any ScreenState)? {
        currentState += 1
        return states[safe: currentState]
    }
    
    public func getPreviousState() -> (any ScreenState)? {
        currentState -= 1
        return states[safe: currentState]
    }
}
