
import UIKit
import FTDomainData
import OutlineTextfield

public final class RegistrationPersonalDataState: BaseRegistrationState, UITextFieldDelegate {
    
    var firstNameTextfield = OutlinedTextfield.ftTextfield(placeholder: "Имя")
    var lastNameTextfield = OutlinedTextfield.ftTextfield(placeholder: "Фамилия")
    var datePickerView = FTDatePickerView()
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(20), firstNameTextfield, lastNameTextfield, datePickerView, nextButton, infoLabel]
    }
    
    public override func apply(user: inout FTUser) {
        user.firstName = firstNameTextfield.text ?? ""
        user.lastName = lastNameTextfield.text ?? ""
    }
    
    //MARK: - UI
    public override func setupViews() {
        setupTitleLabel()
        setupFirstNameTextfield()
        setupLastNameTextfield()
        setupDatePicker()
        setupNextButton()
        setupInfoLabel()
    }
    
    public override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Заполните данные о себе"
    }
    
    private func setupFirstNameTextfield() {
        firstNameTextfield.constraintHeight(DC.Size.buttonHeight)
        firstNameTextfield.placeholder = "Имя"
        firstNameTextfield.delegate = self
        firstNameTextfield.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
    }
    
    private func setupLastNameTextfield() {
        lastNameTextfield.constraintHeight(DC.Size.buttonHeight)
        lastNameTextfield.placeholder = "Фамилия"
        lastNameTextfield.delegate = self
        lastNameTextfield.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
    }
    
    private func setupDatePicker() {
        datePickerView.constraintHeight(DC.Size.buttonHeight)
        datePickerView.addAction(UIAction(handler: checkNextButtonAvailable), for: .valueChanged)
    }
    
    
    public override func isAllFieldsFilled() -> Bool {
        return !(firstNameTextfield.text?.isEmpty ?? true ||
                 lastNameTextfield.text?.isEmpty ?? true ||
                 datePickerView.date == nil)
    }
    
    //MARK: - TextField Delegate
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as? OutlinedTextfield)?.isError = false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextfield {
            let _ = lastNameTextfield.becomeFirstResponder()
        }
        if textField == lastNameTextfield {
            lastNameTextfield.endEditing(true)
            datePickerView.pushAlertDatePicker()
            
        }
        return true
    }
    
    //MARK: - Validation
    public override func validateValues() -> Bool {
        let firstName = validateFirstName()
        let lastName = validateLastName()
        let dateOfBirth = validateDateOfBirth()
        return firstName && lastName && dateOfBirth
    }
    
    private func validateFirstName() -> Bool {
        let result = validator.isValidFirstName(firstNameTextfield.text)
        let isValid = updateFieldInConsistWithValidate(firstNameTextfield, result: result)
        firstNameTextfield.isError = !isValid
        return isValid
    }
    
    private func validateLastName() -> Bool {
        let result = validator.isValidLastName(lastNameTextfield.text)
        let isValid = updateFieldInConsistWithValidate(lastNameTextfield, result: result)
        lastNameTextfield.isError = !isValid
        return isValid
        
    }
    
    private func validateDateOfBirth() -> Bool {
        let result = validator.isValidDateOfBirth(datePickerView.date)
        let isValid = updateFieldInConsistWithValidate(datePickerView, result: result)
        datePickerView.isCorrectDate = isValid
        return isValid
    }

}
