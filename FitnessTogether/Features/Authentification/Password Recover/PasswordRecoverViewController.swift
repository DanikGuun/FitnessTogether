
import UIKit

public final class PasswordRecoverViewController: FTStateViewController {
    
    var delegate: (any PasswordRecoverControllerDelegate)?
    var model: PasswordRecoverModel!
    
    //MARK: - Lifecycle
    public convenience init(model: PasswordRecoverModel) {
        self.init(nibName: nil, bundle: nil)
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
        title = "Восстановление пароля"
        goToNextState()
    }
    
    public override func getNextState() -> (any ScreenState)? {
        return model.goNext()
    }
    
}

public protocol PasswordRecoverControllerDelegate {
    func passwordRecoverDidFinish(_ controller: UIViewController)
}

public extension PasswordRecoverControllerDelegate {
    func passwordRecoverDidFinish(_ controller: UIViewController) {}
}
