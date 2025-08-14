
import UIKit

public final class WorkoutBuilderViewController: FTStateViewController {
    
    var model: WorkoutBuilderModel!
    
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
        goToNextState()
    }
    
    //MARK: - StateManagment
    public override func getNextState() -> (any ScreenState)? {
        return model.getNextState()
    }
}
