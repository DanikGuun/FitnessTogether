
import UIKit
import OutlineTextfield

public final class RegistrationViewController: FTViewController {
    
    var delegate: RegistrationViewControllerDelegate?
    var model: RegistrationModel!
    
    private var states: [RegistrationState] = []
    private var currentState = -1
    
    //MARK: - Lifecycle
    public convenience init(model: RegistrationModel) {
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
        states = model.getStates()
        goToNextState()
    }
    
    let direction = AnimationDirection.up
    private func goToNextState() {
        currentState += 1
        let subviews = states[currentState].viewsToPresent()
        removeAllSubviews(direction: .right, completion: { [weak self] in
            let but = UIButton.ftPlain(title: "чисто чекнуть")
            self?.addSpacing(.fractional(0.1))
            self?.addStackSubviews(subviews + [but], direction: .left)
            but.addAction(UIAction(handler: { _ in
                self?.goToNextState()
            }), for: .touchUpInside)
        })
    }

}

public protocol RegistrationViewControllerDelegate {
    func registrationViewControllerDidFinish(_ controller: UIViewController)
}

extension RegistrationViewControllerDelegate {
    public func registrationViewControllerDidFinish(_ controller: UIViewController) {}
}
