
import UIKit
import OutlineTextField
import FTDomainData

public final class RegistrationCredintalsState: BaseRegistrationState, UITextFieldDelegate {

    var emailConfirmer: (any EmailConfirmer)!
    
    var emailTextField = OutlinedTextField.ftTextField(placeholder: "Электронная почта")
    var passwordTextField = OutlinedTextField.ftTextField(placeholder: "Пароль")
    var confirmPasswordTextField = OutlinedTextField.ftTextField(placeholder: "Повтор пароля")
    var passwordVisibleButton = UIButton(configuration: .plain())
    var confirmPasswordVisibleButton = UIButton(configuration: .plain())
    
    
    init(validator: any Validator, emailConfirmer: any EmailConfirmer) {
        super.init()
        self.validator = validator
        self.emailConfirmer = emailConfirmer
    }
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(20), emailTextField, passwordTextField, confirmPasswordTextField, nextButton, infoLabel]
    }
    
    public override func apply(userRegister: inout FTUserRegister) {
        userRegister.email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        userRegister.password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
    }
    
    public override func setEmptyState() {
        emailTextField.text = nil
        passwordTextField.text = nil
        confirmPasswordTextField.text = nil
        passwordVisibleButton.isSelected = false
        passwordVisibleButtonPressed(nil)
    }
    
    //MARK: - UI
    internal override func setupViews() {
        super.setupViews()
        setupEmailTextField()
        setupTextField(passwordTextField)
        setupTextField(confirmPasswordTextField)
        setupPasswordVisibleButton(passwordVisibleButton, parent: passwordTextField)
        setupPasswordVisibleButton(confirmPasswordVisibleButton, parent: confirmPasswordTextField)
    }
    
    internal override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Заполните поля"
    }
    
    private func setupEmailTextField() {
        emailTextField.constraintHeight(DC.Size.buttonHeight)
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
        emailTextField.delegate = self
        emailTextField.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
    }
    
    private func setupTextField(_ textField: OutlinedTextField) {
        textField.constraintHeight(DC.Size.buttonHeight)
        textField.delegate = self
        textField.textContentType = .password
        textField.autocapitalizationType = .none
        textField.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
        var insets = textField.activeAppearance.insets
        insets.right = 50
        textField.activeAppearance.insets = insets
        textField.standartAppearance.insets = insets
        textField.errorAppearance.insets = insets

    }
    
    private func setupPasswordVisibleButton(_ button: UIButton, parent textField: OutlinedTextField) {
        button.changesSelectionAsPrimaryAction = true
        button.configurationUpdateHandler = passwordVisibleButtonConfigurationUpdateHandler
        textField.addSubview(button)
        button.snp.makeConstraints { maker in
            maker.top.bottom.trailing.equalToSuperview().inset(DC.Layout.insets.right)
        }
        button.addAction(UIAction(handler: passwordVisibleButtonPressed), for: .touchUpInside)
    }
    
    private func passwordVisibleButtonConfigurationUpdateHandler(_ button: UIButton) {
        let imageName = button.isSelected ? "Eye.striked" : "Eye"
        let superTextFieldIsEdiding = (button.superview as? OutlinedTextField)?.isActiveState ?? false
        var conf = button.configuration
        conf?.image = UIImage(named: imageName)
        conf?.baseForegroundColor = superTextFieldIsEdiding ? .label : .systemGray4
        conf?.baseBackgroundColor = .clear
        button.configuration = conf
    }
    
    private func passwordVisibleButtonPressed(_ action: UIAction?) {
        let button = action?.sender as? UIButton
        let isSelected = button?.isSelected ?? false
        passwordVisibleButton.isSelected = isSelected
        confirmPasswordVisibleButton.isSelected = isSelected
        passwordTextField.isSecureTextEntry = isSelected
        confirmPasswordTextField.isSecureTextEntry = isSelected
    }
    
    //MARK: - TextField Delegate
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordVisibleButton.setNeedsUpdateConfiguration()
        confirmPasswordVisibleButton.setNeedsUpdateConfiguration()
        (textField as? OutlinedTextField)?.isError = false
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        passwordVisibleButton.setNeedsUpdateConfiguration()
        confirmPasswordVisibleButton.setNeedsUpdateConfiguration()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        (textField as? OutlinedTextField)?.isError = false
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            let _ = passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            let _ = confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField {
            let _ = confirmPasswordTextField.resignFirstResponder()
            nextButtonPressed(nil)
        }
        return true
    }
    
    //MARK: - Custom NextButton для проверки почты
    override func nextButtonPressed(_ action: UIAction?) {
        if validateValues() && !isNextButtonBusy {
            setNextButtonBusy(true)
            emailConfirmer.confirmEmail(emailTextField.text ?? "", completion: { [weak self] result in
                guard let self else { return }
                self.setNextButtonBusy(false)
                let isValid = self.updateFieldInConsistWithValidate(self.emailTextField, result: result)
                emailTextField.isError = !isValid
                if isValid {
                    self.delegate?.screenStateGoNext(self)
                }
            })
        }
    }
    
    
    //MARK: - Validation
    override func validateValues() -> Bool {
        let email = validateEmail()
        let password = validatePassword()
        let confirmPassword = validateConfirmPassword()
        return email && password && confirmPassword
    }
    
    private func validateEmail() -> Bool {
        let result = validator.isValidEmail(emailTextField.text)
        let isValid = updateFieldInConsistWithValidate(emailTextField, result: result)
        emailTextField.isError = !isValid
        return isValid
    }
    
    private func validatePassword() -> Bool {
        let result = validator.isValidPassword(passwordTextField.text)
        let isValid = updateFieldInConsistWithValidate(passwordTextField, result: result)
        passwordTextField.isError = !isValid
        return isValid
    }
    
    private func validateConfirmPassword() -> Bool {
        let result = validator.isValidPasswordConfirmation(passwordTextField.text, confirmPasswordTextField.text)
        let isValid = updateFieldInConsistWithValidate(confirmPasswordTextField, result: result)
        confirmPasswordTextField.isError = !isValid
        return isValid
    }
    
    override func isAllFieldsFilled() -> Bool {
        return !(
            emailTextField.text?.isEmpty ?? true ||
            passwordTextField.text?.isEmpty ?? true ||
            confirmPasswordTextField.text?.isEmpty ?? true
        )
    }
    
}

