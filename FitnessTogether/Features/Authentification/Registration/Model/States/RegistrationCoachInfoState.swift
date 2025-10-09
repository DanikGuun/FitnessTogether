
import UIKit
import FTDomainData
import OutlineTextField

public final class RegistrationCoachInfoState: BaseRegistrationState, UITextFieldDelegate, UITextViewDelegate {
    
    var workExperienceTextField = OutlinedTextField.ftTextField(placeholder: "Опыт работы")
    var organizationTextField = OutlinedTextField.ftTextField(placeholder: "Организация")
    var descriptionTextView = PlaceholderTextView.ftTextView(placeholder: "О себе (не более 200 символов)")
    
    public init(validator: Validator) {
        super.init()
        self.validator = validator
    }
    
    public override func apply(userRegister: inout FTUserRegister) {
        userRegister.workExperience = workExperienceTextField.text?.doubleValue
        userRegister.organization = organizationTextField.text
        userRegister.description = descriptionTextView.text
    }
    
    public override func viewsToPresent() -> [UIView] {
        descriptionTextView.constraintHeight(150)
        return [titleLabel, workExperienceTextField, organizationTextField, descriptionTextView, nextButton, infoLabel]
    }
    
    public override func setEmptyState() {
        workExperienceTextField.text = nil
        organizationTextField.text = nil
        descriptionTextView.text = nil
    }
    
    //
    override func setupViews() {
        super.setupViews()
        setupTextField(workExperienceTextField)
        workExperienceTextField.keyboardType = .decimalPad
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
        textView.layoutSubviews()
    }
    
    //MARK: - TextField Delegate
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == workExperienceTextField {
            let _ = organizationTextField.becomeFirstResponder()
        }
        else if textField == organizationTextField {
            let _ = descriptionTextView.becomeFirstResponder()
        }
        return true
    }
    
    //MARK: - Validation
    
    override func validateValues() -> Bool {
        let jobTime = validateWorkExperience()
        let description = validateDescription()
        return jobTime && description
    }
    
    private func validateWorkExperience() -> Bool {
        let time = workExperienceTextField.text?.doubleValue
        let result = validator.isValidWorkExperience(time)
        let isValid = updateFieldInConsistWithValidate(workExperienceTextField, result: result)
        workExperienceTextField.isError = !isValid
        return isValid
    }
    
    private func validateDescription() -> Bool {
        let result = validator.isValidDescription(descriptionTextView.text)
        let isValid = updateFieldInConsistWithValidate(descriptionTextView, result: result)
        descriptionTextView.isError = !isValid
        return isValid
    }
    
    override func isAllFieldsFilled() -> Bool {
        return !(workExperienceTextField.text?.isEmpty ?? true ||
                 organizationTextField.text?.isEmpty ?? true)
    }
    
}
