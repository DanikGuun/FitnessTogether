
import UIKit
import OutlineTextField

public final class PasswordRecoverEmailState: BaseFieldsScreenState, PasswordRecoverState, UITextFieldDelegate {

    let emailTextField = OutlinedTextField.ftTextField(placeholder: "Email")
    
    private var emailConfirmer: any EmailConfirmer
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(24), emailTextField, nextButton]
    }
    
    public func apply() {
        
    }
    
    public init(validator: Validator, emailConfirmer: any EmailConfirmer) {
        self.emailConfirmer = emailConfirmer
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
            setNextButtonBusy(true)
            emailConfirmer.isEmailExist(emailTextField.text ?? "") { [weak self] result in
                guard let self else { return }
                setNextButtonBusy(false)
                let isValid = updateFieldInConsistWithValidate(emailTextField, result: result)
                if isValid {
                    delegate?.screenStateGoNext(self)
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
