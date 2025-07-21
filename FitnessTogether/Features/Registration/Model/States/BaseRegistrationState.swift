
import UIKit
import FTDomainData

open class BaseRegistrationState: NSObject, RegistrationState {
    
    public var delegate: (any RegistrationStateDelegate)?
    public var validator: Validator
    
    //некорректные вьюшки и подписи для них
    private var incorrectDataLabels: [UIView: UIView] = [:]
    
    var titleLabel = UILabel()
    var nextButton = UIButton.ftFilled(title: "Далее")
    var infoLabel = UILabel()
    
    public init(validator: Validator) {
        self.validator = validator
        super.init()
        setupViews()
    }
    
    public func viewsToPresent() -> [UIView] {
        return []
    }
    
    public func apply(userRegister: inout FTUserRegister) {
    }
    
    //MARK: - UI
    //Override
    internal func setupViews() {
        setupTitleLabel()
        setupNextButton()
        setupInfoLabel()
    }
    
    //Override для надписи
    internal func setupTitleLabel() {
        titleLabel.font = DC.Font.headline
    }
    
    internal func setupNextButton() {
        nextButton.isEnabled = false
        nextButton.constraintHeight(DC.Size.buttonHeight)
        nextButton.addAction(UIAction(handler: nextButtonPressed), for: .touchUpInside)
    }
    
    internal func checkNextButtonAvailable(_ action: UIAction?) {
        nextButton.isEnabled = isAllFieldsFilled()
    }
    
    //Override
    internal func isAllFieldsFilled() -> Bool {
        return true
    }
    
    internal func setupInfoLabel() {
        infoLabel.text = "Регистрируясь, вы соглашаетесь с условиями\nиспользования приложения и политикой конфиденциальности"
        infoLabel.textColor = .systemGray4
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = DC.Font.additionalInfo
    }
    
    
    //MARK: - Actions
    internal func nextButtonPressed(_ action: UIAction?) {
        if validateValues() {
            delegate?.registrationStateGoNext(self)
        }
    }
    
    //MARK: - Validation
    //Override
    internal func validateValues() -> Bool {
        return false
    }
    
    @discardableResult internal func updateFieldInConsistWithValidate(_ field: UIView, result: ValidatorResult) -> Bool {
        
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
