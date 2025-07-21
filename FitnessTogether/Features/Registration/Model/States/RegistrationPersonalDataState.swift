
import UIKit
import FTDomainData
import OutlineTextfield

public final class RegistrationPersonalDataState: NSObject, RegistrationState, UITextFieldDelegate {
    
    public var delegate: (any RegistrationStateDelegate)?
    public var validator: Validator
    
    //некорректные вьюшки и подписи для них
    private var incorrectDataLabels: [UIView: UIView] = [:]
    
    var titleLabel = UILabel()
    var firstNameTextfield = OutlinedTextfield.ftTextfield(placeholder: "Имя")
    var lastNameTextfield = OutlinedTextfield.ftTextfield(placeholder: "Фамилия")
    var datePickerView = FTDatePickerView()
    var nextButton = UIButton.ftFilled(title: "Далее")
    var infoLabel = UILabel()
    
    public init(validator: Validator) {
        self.validator = validator
        super.init()
        setupViews()
    }
    
    public func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(20), firstNameTextfield, lastNameTextfield, datePickerView, nextButton, infoLabel]
    }
    
    public func apply(user: inout FTUser) {
        user.firstName = firstNameTextfield.text ?? ""
        user.lastName = lastNameTextfield.text ?? ""
    }
    
    //MARK: - UI
    private func setupViews() {
        setupTitleLabel()
        setupFirstNameTextfield()
        setupLastNameTextfield()
        setupDatePicker()
        setupNextButton()
        setupInfoLabel()
        
    }
    
    private func setupTitleLabel() {
        titleLabel.font = DC.Font.headline
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
    
    private func setupNextButton() {
        nextButton.isEnabled = false
        nextButton.constraintHeight(DC.Size.buttonHeight)
        nextButton.addAction(UIAction(handler: nextButtonPressed), for: .touchUpInside)
    }
    
    func checkNextButtonAvailable(_ action: UIAction?) {
        nextButton.isEnabled = isAllFieldsFilled()
    }
    
    private func isAllFieldsFilled() -> Bool {
        return !(firstNameTextfield.text?.isEmpty ?? true ||
                 lastNameTextfield.text?.isEmpty ?? true ||
                 datePickerView.date == nil)
    }
    
    private func setupInfoLabel() {
        infoLabel.text = "Регистрируясь, вы соглашаетесь с условиями\nиспользования приложения и политикой конфиденциальности"
        infoLabel.textColor = .systemGray4
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = DC.Font.additionalInfo
    }
    
    //MARK: - TextField Delegate
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        (textField as? OutlinedTextfield)?.isError = false
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameTextfield {
            lastNameTextfield.becomeFirstResponder()
        }
        if textField == lastNameTextfield {
            lastNameTextfield.endEditing(true)
            datePickerView.pushAlertDatePicker()
            
        }
        return true
    }
    
    //MARK: - Actions
    func nextButtonPressed(_ action: UIAction?) {
        if validateValues() {
            delegate?.registrationStateGoNext(self)
        }
    }
    
    //MARK: - Validation
    private func validateValues() -> Bool {
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
    
    private func updateFieldInConsistWithValidate(_ field: UIView, result: ValidatorResult) -> Bool {
        
        var isValid: Bool = false
        var incorrectMessage: String? = ""
        switch result {
        case .valid:
            isValid = true
        case .invalid(let message):
            isValid = false
            incorrectMessage = message
        }
        
        //если валидное, удаляем лейбл если есть
        if isValid {
            if let label = incorrectDataLabels[field] {
                delegate?.registrationState(self, needRemoveView: label)
            }
        }
        //чтобы не добавлять второй раз и при пустом
        else if incorrectDataLabels[field] == nil, let incorrectMessage {
            let label = UILabel.incorrectData(incorrectMessage)
            delegate?.registrationState(self, needInertView: label, after: field)
            incorrectDataLabels[field] = label
        }
        
        return isValid
    }
    

}
