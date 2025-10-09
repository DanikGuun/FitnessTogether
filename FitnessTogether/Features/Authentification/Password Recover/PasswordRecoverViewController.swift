
import UIKit

public final class PasswordRecoverViewController: FTStateViewController {
    
    var delegate: (any PasswordRecoverControllerDelegate)?
    var model: PasswordRecoverModel!
    
    let stepLabel = UILabel.secondary(nil)
    private var step: Int = 0
    
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
        setupStepLabel()
        goToNextState()
    }
    
    public override func viewStatesDidEnd() {
        model.resetPassword(completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(_):
                delegate?.passwordRecoverDidFinish(self)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    private func setupStepLabel() {
        view.addSubview(stepLabel)
        stepLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(90)
        }
    }
    
    private func updateStepLabel() {
        let text = "Шаг \(step) из \(max(step, model.stepCount))"
        stepLabel.text = text
    }
    
    public override func goToNextState() {
        super.goToNextState()
        step += 1
        updateStepLabel()
    }
    
    public override func getNextState() -> (any ScreenState)? {
        return model.goNext()
    }
    
    public override func getPreviousState() -> (any ScreenState)? {
        return model.getPreviousState()
    }
    
    public override func isFirstState() -> Bool {
        return model.currentStep <= 0
    }
    
}

public protocol PasswordRecoverControllerDelegate {
    func passwordRecoverDidFinish(_ controller: UIViewController)
}

public extension PasswordRecoverControllerDelegate {
    func passwordRecoverDidFinish(_ controller: UIViewController) {}
}
