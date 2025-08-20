
import OutlineTextField
import FTDomainData
import UIKit

public final class PasswordRecoverNewPasswordState: BaseFieldsScreenState, PasswordRecoverState, UITextFieldDelegate {
    
    var passwordTextField = OutlinedTextField.ftTextField(placeholder: "Пароль")
    var confirmPasswordTextField = OutlinedTextField.ftTextField(placeholder: "Повтор пароля")
    var passwordVisibleButton = UIButton(configuration: .plain())
    var confirmPasswordVisibleButton = UIButton(configuration: .plain())
    
    public func apply(to resetData: inout FTResetPassword) {
        resetData.newPassword = passwordTextField.text ?? ""
    }
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(24), passwordTextField, confirmPasswordTextField, nextButton]
    }
    
    init(validator: any Validator) {
        super.init()
        self.validator = validator
    }
    
    //MARK: - UI
    override func setupViews() {
        super.setupViews()
        setupTextField(passwordTextField)
        setupTextField(confirmPasswordTextField)
        setupPasswordVisibleButton(passwordVisibleButton, parent: passwordTextField)
        setupPasswordVisibleButton(confirmPasswordVisibleButton, parent: confirmPasswordTextField)
    }
    
    override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Придумайте новый пароль"
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
        let imageName = button.isSelected ? "eye.striked" : "eye"
        let superTextFieldIsEdiding = (button.superview as? OutlinedTextField)?.isActiveState ?? false
        var conf = button.configuration
        conf?.image = UIImage(named: imageName)
        conf?.baseForegroundColor = superTextFieldIsEdiding ? .label : .systemGray4
        conf?.baseBackgroundColor = .clear
        button.configuration = conf
    }
    
    private func passwordVisibleButtonPressed(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        passwordVisibleButton.isSelected = button.isSelected
        confirmPasswordVisibleButton.isSelected = button.isSelected
        passwordTextField.isSecureTextEntry = button.isSelected
        confirmPasswordTextField.isSecureTextEntry = button.isSelected
    }
    
    override func isAllFieldsFilled() -> Bool {
        return (passwordTextField.text ?? "").isEmpty == false &&
        (confirmPasswordTextField.text ?? "").isEmpty == false
    }
    
    //MARK: - TextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            let _ = confirmPasswordTextField.becomeFirstResponder()
        }
        else if textField == confirmPasswordTextField {
            nextButtonPressed(nil)
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as! OutlinedTextField).isError = false
        passwordVisibleButton.setNeedsUpdateConfiguration()
        confirmPasswordVisibleButton.setNeedsUpdateConfiguration()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        passwordVisibleButton.setNeedsUpdateConfiguration()
        confirmPasswordVisibleButton.setNeedsUpdateConfiguration()
    }
    
    //MARK: - Validating
    override func validateValues() -> Bool {
        let password = validatePassword()
        let confirmPassword = validateConfirmPassword()
        return password && confirmPassword
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
    
}
