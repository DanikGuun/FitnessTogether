
public final class BaseWorkoutBuilderModel: WorkoutBuilderModel {
    
    let states: [any ScreenState]
    
    init() {
        states = [
            WorkoutBuilderMetaState()
        ]
    }
    
    public func getNextState() -> any ScreenState {
        return states[0]
    }
}
