
import UIKit
import OutlineTextField

public final class RegistrationCoachInfoState: BaseRegistrationState, UITextFieldDelegate, UITextViewDelegate {
    
    var jobTimeTextField = OutlinedTextField.ftTextField(placeholder: "Опыт работы")
    var organizationTextField = OutlinedTextField.ftTextField(placeholder: "Организация")
    var descriptionTextView = PlaceholderTextView.ftTextView(placeholder: "О себе (не более 200 символов)")
    
    public init(validator: Validator) {
        super.init()
        self.validator = validator
    }
    
    public override func viewsToPresent() -> [UIView] {
        descriptionTextView.constraintHeight(150)
        return [titleLabel, jobTimeTextField, organizationTextField, descriptionTextView, nextButton, infoLabel]
    }
    
    override func setupViews() {
        super.setupViews()
        setupTextField(jobTimeTextField)
        jobTimeTextField.keyboardType = .decimalPad
        setupTextField(organizationTextField)
        setupSescriptionTextView()
    }
    
    private func setupTextField(_ textField: UITextField) {
        textField.addAction(UIAction(handler: checkNextButtonAvailable), for: .editingChanged)
        textField.delegate = self
    }
    
    private func setupSescriptionTextView() {
        descriptionTextView.constraintHeight(150)
        descriptionTextView.delegate = self
    }
    
    //MARK: - TextView Delegate
    public func textViewDidChange(_ textView: UITextView) {
        checkNextButtonAvailable(nil)
    }
    
    //MARK: - TextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == jobTimeTextField {
            let _ = organizationTextField.becomeFirstResponder()
        }
        else if textField == organizationTextField {
            let _ = descriptionTextView.becomeFirstResponder()
        }
        return true
    }
    
    //MARK: - Validation
    
    override func validateValues() -> Bool {
        let jobTime = validateJobTime()
        let description = validateDescription()
        return jobTime && description
    }
    
    private func validateJobTime() -> Bool {
        let time = Double(jobTimeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let result = validator.isValidJobTime(time)
        let isValid = updateFieldInConsistWithValidate(jobTimeTextField, result: result)
        jobTimeTextField.isError = !isValid
        return isValid
    }
    
    private func validateDescription() -> Bool {
        let result = validator.isValidDescription(descriptionTextView.text)
        let isValid = updateFieldInConsistWithValidate(descriptionTextView, result: result)
        descriptionTextView.isError = !isValid
        return isValid
    }
    
    override func isAllFieldsFilled() -> Bool {
        return !(jobTimeTextField.text?.isEmpty ?? true ||
                 organizationTextField.text?.isEmpty ?? true)
    }
    
}
