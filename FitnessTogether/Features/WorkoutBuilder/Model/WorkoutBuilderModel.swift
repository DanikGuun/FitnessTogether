
import FTDomainData

public protocol WorkoutBuilderModel {
    var currentState: Int { get }
    func getNextState() -> (any ScreenState)?
    func getPreviousState() -> (any ScreenState)?
    func saveWorkoutAndExercises(completion: ((Result<Void, Error>) -> (Void))?)
}

public class BaseWorkoutBuilderModel: WorkoutBuilderModel {
    public private(set) var currentState = -1
    let states: [any WorkoutBuilderState]
    
    var ftmanager: FTManager
    var workout = FTWorkoutCreate()
    var exercises: [FTExerciseCreate] = []
    
    init(ftManager: FTManager) {
        self.ftmanager = ftManager
        let clientProvider = FTUserAdapterClientProvider(ftUser: ftManager.user)
        states = [
            WorkoutBuilderMetaState(clientsProvider: clientProvider),
            WorkoutBuilderExerciseState()
        ]
    }
    
    public func getNextState() -> (any ScreenState)? {
        applyDataIfNeeded()
        guard currentState < states.count - 1 else { return nil }
        currentState += 1
        return states[safe: currentState]
    }
    
    public func getPreviousState() -> (any ScreenState)? {
        guard currentState > 0 else { return nil }
        currentState -= 1
        return states[safe: currentState]
    }
    
    internal func applyDataIfNeeded() {
        guard let state = states[safe: currentState] else { return }
        state.apply(workoutCreate: &workout, exercises: &exercises)
    }
    
    public func saveWorkoutAndExercises(completion: ((Result<Void, any Error>) -> (Void))?) { }
}
