
import UIKit

public final class WorkoutBuilderViewController: FTStateViewController, WorkoutBuilderStateDelegate {
    var model: WorkoutBuilderModel!
    var delegate: (any WorkoutBuilderViewControllerDelegate)?
    
    //MARK: - Lifecycle
    public convenience init(model: WorkoutBuilderModel) {
        self.init(nibName: nil, bundle: nil)
        firstSpacingHeight = .fixed(0)
        self.model = model
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.keyboardDismissMode = .onDrag
        goToNextState()
    }
    
    public func workoutBuilderStateRequestToAddExercise(_ state: (any WorkoutBuilderState)) {
        delegate?.workoutBuilderVCRequestToOpenAddExerciseScreen(self)
    }
    
    public override func viewStatesDidEnd() {
        model.addWorkoutAndExercises(completion: { result in
            switch result {
                
            case .success:
                self.delegate?.workoutBuilderVCDidFinish(self)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
            
        })
    }
    
    //MARK: - StateManagment
    public override func getNextState() -> (any ScreenState)? {
        return model.getNextState()
    }
    
    public override func getPreviousState() -> (any ScreenState)? {
        return model.getPreviousState()
    }
    
    public override func isFirstState() -> Bool {
        return model.currentState <= 0
    }
}

public protocol WorkoutBuilderViewControllerDelegate {
    func workoutBuilderVCRequestToOpenAddExerciseScreen(_ vc: UIViewController)
    func workoutBuilderVCDidFinish(_ vc: UIViewController)
}

public extension WorkoutBuilderViewControllerDelegate {
    func workoutBuilderVCRequestToOpenAddExerciseScreen(_ vc: UIViewController) {}
    func workoutBuilderVCDidFinish(_ vc: UIViewController) {}
}
