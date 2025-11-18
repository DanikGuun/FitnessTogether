
import UIKit
import FTDomainData

public final class PasswordRecoverCodeState: BaseFieldsScreenState, PasswordRecoverState {
    
    let codeTextField = FTPinCodeTextField()
    let sendCodeAgainButton: UIButton = UIButton.secondaryButton(title: "Отправить код повторно")
    
    let recoverManager: PasswordRecoverNetworkManager
    
    init(recoverManager: PasswordRecoverNetworkManager) {
        self.recoverManager = recoverManager
    }
    
    public func apply(to resetData: inout FTResetPassword) {
        resetData.resetCode = codeTextField.code
    }
    
    public override func viewsToPresent() -> [UIView] {
        DispatchQueue.main.async { [weak self] in
            self?.showCodeSendAlert()
            self?.codeTextField.becomeFirstResponder()
        }
        return [titleLabel, UIView.spaceView(24), codeTextField, nextButton, sendCodeAgainButton]
    }
    
    //MARK: - UI
    public override func setupViews() {
        super.setupViews()
        setupCodeTextField()
        setupSendCodeAgainButton()
    }
    
    override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Введите полученный код"
    }
    
    private func setupCodeTextField() {
        codeTextField.constraintHeight(DC.Size.buttonHeight)

        codeTextField.onCodeChanged = { [weak self] code in
            self?.codeTextFieldHasUpdated(nil)
        }
        
        codeTextField.onCodeFinich = { [weak self] code in
            self?.nextButtonPressed(nil)
        }
        
        codeTextField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func codeTextFieldHasUpdated(_ action: UIAction?) {
        checkNextButtonAvailable(nil)
    }
    
    private func setupSendCodeAgainButton() {
        sendCodeAgainButton.addAction(UIAction(handler: sendCodeAgainButtonPressed), for: .touchUpInside)
    }
    
    func sendCodeAgainButtonPressed(_ action: UIAction?) {
        setNextButtonBusy(true)
        codeTextField.clear()
        recoverManager.sendEmailCodeAgain(completion: { [weak self] _ in
            self?.setNextButtonBusy(false)
        })
    }
    
    override func isAllFieldsFilled() -> Bool {
        return codeTextField.isAllCharactersFilled
    }

    
    //MARK: - Other
    
    override func nextButtonPressed(_ action: UIAction?) {
        setNextButtonBusy(true)
        recoverManager.isEmailCodeValid(codeTextField.code, completion: { [weak self] result in
            guard let self else { return }
            
            setNextButtonBusy(false)
            let isValid = updateFieldInConsistWithValidate(codeTextField, result: result)
            if isValid {
                codeTextField.resetError()
            }
            else {
                codeTextField.showError()
            }
            if isValid {
                delegate?.screenStateGoNext(self)
            }
        })
    }
    
    private func showCodeSendAlert() {
        guard let parent = nextButton.viewController?.view else { return }
        let controller = UIViewController()
        controller.view.backgroundColor = .systemBackground
        
        let label = UILabel.headline("На указанный вами email отправлен код для входа в аккаунт")
        controller.view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(20)
        }
        
        nextButton.viewController?.presentPopover(controller, size: CGSize(width: parent.bounds.width, height: 200), sourceView: nextButton)
    }
}
