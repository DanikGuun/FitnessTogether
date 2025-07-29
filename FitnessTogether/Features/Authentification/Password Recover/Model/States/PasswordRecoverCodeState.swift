
import UIKit

public final class PasswordRecoverCodeState: BaseFieldsScreenState, PasswordRecoverState {
    
    let codeTextField = FTEmailCodeTextField()
    
    let emailConfirmer: EmailConfirmer
    
    init(emailConfirmer: EmailConfirmer) {
        self.emailConfirmer = emailConfirmer
    }
    
    public func apply() {
        
    }
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(24), codeTextField, nextButton]
    }
    
    public override func setupViews() {
        super.setupViews()
        setupCodeTextField()
        
    }
    
    override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Введите полученный код"
    }
    
    private func setupCodeTextField() {
        codeTextField.constraintHeight(DC.Size.buttonHeight)
        codeTextField.addAction(UIAction(handler: codeTextFieldHasUpdated), for: .editingChanged)
        codeTextField.addAction(UIAction(handler: nextButtonPressed(_:)), for: .editingDidEnd)
    }
    
    private func codeTextFieldHasUpdated(_ action: UIAction) {
        checkNextButtonAvailable(nil)
    }
    
    override func isAllFieldsFilled() -> Bool {
        return codeTextField.isAllCharactersFilled
    }
    
    override func nextButtonPressed(_ action: UIAction?) {
        setNextButtonBusy(true)
        emailConfirmer.isEmailCodeValid(codeTextField.text, completion: { [weak self] result in
            guard let self else { return }
            
            setNextButtonBusy(false)
            let isValid = updateFieldInConsistWithValidate(codeTextField, result: result)
            codeTextField.isError = !isValid
            if isValid {
                delegate?.screenStateGoNext(self)
            }
        })
    }
}
