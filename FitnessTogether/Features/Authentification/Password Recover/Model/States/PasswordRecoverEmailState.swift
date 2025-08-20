
import UIKit
import FTDomainData
import OutlineTextField

public final class PasswordRecoverEmailState: BaseFieldsScreenState, PasswordRecoverState, UITextFieldDelegate {

    let emailTextField = OutlinedTextField.ftTextField(placeholder: "Email")
    
    private var recoverManager: any PasswordRecoverNetworkManager
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(24), emailTextField, nextButton]
    }
    
    public func apply(to resetData: inout FTResetPassword) {
        resetData.email = emailTextField.text ?? ""
    }
    
    public init(validator: Validator, recoverManager: any PasswordRecoverNetworkManager) {
        self.recoverManager = recoverManager
        super.init()
        self.validator = validator
    }
    
    override func setupViews() {
        super.setupViews()
        setupEmailTextfield()
    }
    
    override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Укажите ваш email для входа в аккаунт"
    }
    
    private func setupEmailTextfield() {
        emailTextField.delegate = self
        emailTextField.autocorrectionType = .no
        emailTextField.spellCheckingType = .no
        emailTextField.autocapitalizationType = .none
    }
    
    override func nextButtonPressed(_ action: UIAction?) {
        if validateValues() {
            let email = emailTextField.text ?? ""
            setNextButtonBusy(true)
            recoverManager.isEmailExist(email) { [weak self] result in
                guard let self else { return }
                let isValid = updateFieldInConsistWithValidate(emailTextField, result: result)
                if isValid {
                    recoverManager.sendEmailCode(email, completion: { _ in
                        self.delegate?.screenStateGoNext(self)
                        self.setNextButtonBusy(false)
                    })
                }
            }
        }
    }
    
    //MARK: - UITextFieldDelegate
    
    public func textFieldDidChangeSelection(_ textField: UITextField) {
        (textField as? OutlinedTextField)?.isError = false
        checkNextButtonAvailable(nil)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            nextButtonPressed(nil)
        }
        return true
    }
    
    //MARK: - Валидация
    override func isAllFieldsFilled() -> Bool {
        return !(emailTextField.text?.isEmpty ?? true)
    }
    
    override func validateValues() -> Bool {
        validateEmail()
    }
    
    private func validateEmail() -> Bool {
        let result = validator.isValidEmail(emailTextField.text)
        let isValid = updateFieldInConsistWithValidate(emailTextField, result: result)
        emailTextField.isError = !isValid
        return isValid
    }
    
}
