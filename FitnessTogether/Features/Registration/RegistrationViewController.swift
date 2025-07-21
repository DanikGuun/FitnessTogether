
import UIKit
import FTDomainData

public final class RegistrationViewController: FTViewController, RegistrationStateDelegate {
    
    var delegate: RegistrationViewControllerDelegate?
    var model: RegistrationModel!
    
    var userRegister = FTUserRegister()
    private var states: [RegistrationState] = []
    private var currentState = -1
    private var stepLabel = UILabel()
    
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
        setupStepLabel()
    }
    
    private func goToNextState() {
        currentState += 1
        states[currentState].delegate = self
        let subviews = states[currentState].viewsToPresent()
        removeAllStackSubviews(direction: .right, completion: { [weak self] in
            self?.addSpacing(.fractional(0.1))
            self?.addStackSubviews(subviews, direction: .left)
        })
        updateStepLabel()
    }
    
    private func setupStepLabel() {
        view.addSubview(stepLabel)
        stepLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(90)
        }
        
        stepLabel.font = DC.Font.roboto(weight: .regular, size: 15)
        stepLabel.textColor = UIColor.systemGray3
    }
    
    private func updateStepLabel() {
        stepLabel.text = "\(currentState + 1) из \(states.count) шагов"
    }
    
    public func registrationStateGoNext(_ state: any RegistrationState) {
        state.apply(userRegister: &userRegister)
        goToNextState()
    }
    
    public func registrationState(_ state: any RegistrationState, needInertView view: UIView, after afterView: UIView) {
        guard let index = stackView.arrangedSubviews.firstIndex(of: afterView) else { return }
        stackView.insertArrangedSubview(view, at: index + 1)
    }

    public func registrationState(_ state: any RegistrationState, needRemoveView view: UIView) {
        stackView.removeArrangedSubview(view)
        view.removeFromSuperview()
    }
    
}

public protocol RegistrationViewControllerDelegate {
    func registrationViewControllerDidFinish(_ controller: UIViewController)
}

extension RegistrationViewControllerDelegate {
    public func registrationViewControllerDidFinish(_ controller: UIViewController) {}
}
