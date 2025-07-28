
import UIKit
import FTDomainData

public final class RegistrationViewController: FTStateViewController {
    
    var delegate: (any RegistrationViewControllerDelegate)?
    var model: RegistrationModel!
    
    private var stepLabel = UILabel()
    private var currentStep = 0
    
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
    
    public override func viewStatesDidEnd() {
        delegate?.registrationViewControllerDidFinish(self)
    }
    
    public override func getNextState() -> (any ScreenState)? {
        return model.goNext()
    }
    
    public override func goToNextState() {
        super.goToNextState()
        
        currentStep += 1
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
        stepLabel.text = "\(currentStep) из \(max(currentStep, model.stepCount)) шагов"
    }
    
}

public protocol RegistrationViewControllerDelegate {
    func registrationViewControllerDidFinish(_ controller: UIViewController)
}

extension RegistrationViewControllerDelegate {
    public func registrationViewControllerDidFinish(_ controller: UIViewController) {}
}
