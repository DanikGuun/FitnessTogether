
import UIKit
import FTDomainData

public final class RegistrationViewController: FTStateViewController {
    
    var delegate: (any RegistrationViewControllerDelegate)?
    var model: RegistrationModel!
    
    private var stepLabel = UILabel.secondary(nil)
    private var currentStep = 0
    private var isRegistrationCompleted = false
    
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
        goToNextState()
        setupStepLabel()
    }
    
    private func setupStepLabel() {
        view.addSubview(stepLabel)
        stepLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(90)
        }
    }
    
    private func updateStepLabel() {
        guard isRegistrationCompleted == false else { return }
        stepLabel.text = "\(currentStep) из \(max(currentStep, model.stepCount)) шагов"
    }
    
    public override func viewStatesDidEnd() {
        view.isUserInteractionEnabled = false
        model.register(user: model.userRegister, completion: { [weak self] result in
            guard let self else { return }
            view.isUserInteractionEnabled = true
            switch result {
            case .success(_):
                delegate?.registrationViewControllerDidFinish(self)
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    public override func goToNextState() {
        super.goToNextState()
        currentStep += 1
        updateStepLabel()
    }
    
    public override func goToPreviousState() {
        super.goToPreviousState()
        currentStep -= 1
        updateStepLabel()
    }
    
    public override func getNextState() -> (any ScreenState)? {
        let state = model.goNext()
        isRegistrationCompleted = state == nil
        return state
    }
    
    public override func getPreviousState() -> (any ScreenState)? {
        return model.popPreviousState()
    }
    
    public override func isFirstState() -> Bool {
        return model.currentState <= 0
    }
    
}

public protocol RegistrationViewControllerDelegate {
    func registrationViewControllerDidFinish(_ controller: UIViewController)
}

extension RegistrationViewControllerDelegate {
    public func registrationViewControllerDidFinish(_ controller: UIViewController) {}
}
