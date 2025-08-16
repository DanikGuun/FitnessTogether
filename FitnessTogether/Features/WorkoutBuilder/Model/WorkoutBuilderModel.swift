
public protocol WorkoutBuilderModel {
    var currentState: Int { get }
    func getNextState() -> (any ScreenState)?
    func getPreviousState() -> (any ScreenState)?
}
