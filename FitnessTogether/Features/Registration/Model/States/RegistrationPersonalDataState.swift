
import UIKit
import FTDomainData
import OutlineTextField

public final class RegistrationPersonalDataState: BaseRegistrationState, UITextFieldDelegate {
    
    var firstNameTextField = OutlinedTextField.ftTextField(placeholder: "Имя")
    var lastNameTextField = OutlinedTextField.ftTextField(placeholder: "Фамилия")
    var datePickerView = FTDatePickerView()
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(20), firstNameTextField, lastNameTextField, datePickerView, nextButton, infoLabel]
    }
    
    public override func apply(userRegister: inout FTUserRegister) {
        userRegister.firstName = firstNameTextField.text ?? ""
        userRegister.lastName = lastNameTextField.text ?? ""
    }
    
    //MARK: - UI
    internal override func setupViews() {
        setupTitleLabel()
        setupFirstNameTextField()
        setupLastNameTextField()
        setupDatePicker()
        setupNextButton()
        setupInfoLabel()
    }
    
    internal override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Заполните данные о себе"
    }
    
    private func setupFirstNameTextField() {
        firstNameTextField.constraintHeight(DC.Size.buttonHeight)
        firstNameTextField.delegate = self
        firstNameTextField.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
    }
    
    private func setupLastNameTextField() {
        lastNameTextField.constraintHeight(DC.Size.buttonHeight)
        lastNameTextField.delegate = self
        lastNameTextField.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
    }
    
    private func setupDatePicker() {
        datePickerView.constraintHeight(DC.Size.buttonHeight)
        datePickerView.addAction(UIAction(handler: checkNextButtonAvailable), for: .valueChanged)
    }
    
    //MARK: - TextField Delegate
    internal func TextFieldDidBeginEditing(_ TextField: UITextField) {
        (TextField as? OutlinedTextField)?.isError = false
    }
    
    internal func TextFieldShouldReturn(_ TextField: UITextField) -> Bool {
        if TextField == firstNameTextField {
            let _ = lastNameTextField.becomeFirstResponder()
        }
        if TextField == lastNameTextField {
            lastNameTextField.endEditing(true)
            datePickerView.pushAlertDatePicker()
            
        }
        return true
    }
    
    //MARK: - Validation
    internal override func validateValues() -> Bool {
        let firstName = validateFirstName()
        let lastName = validateLastName()
        let dateOfBirth = validateDateOfBirth()
        return firstName && lastName && dateOfBirth
    }
    
    private func validateFirstName() -> Bool {
        let result = validator.isValidFirstName(firstNameTextField.text)
        let isValid = updateFieldInConsistWithValidate(firstNameTextField, result: result)
        firstNameTextField.isError = !isValid
        return isValid
    }
    
    private func validateLastName() -> Bool {
        let result = validator.isValidLastName(lastNameTextField.text)
        let isValid = updateFieldInConsistWithValidate(lastNameTextField, result: result)
        lastNameTextField.isError = !isValid
        return isValid
        
    }
    
    private func validateDateOfBirth() -> Bool {
        let result = validator.isValidDateOfBirth(datePickerView.date)
        let isValid = updateFieldInConsistWithValidate(datePickerView, result: result)
        datePickerView.isCorrectDate = isValid
        return isValid
    }
    
    internal override func isAllFieldsFilled() -> Bool {
        return !(firstNameTextField.text?.isEmpty ?? true ||
                 lastNameTextField.text?.isEmpty ?? true ||
                 datePickerView.date == nil)
    }

}
