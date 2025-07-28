
import UIKit

open class BaseFieldsScreenState: NSObject, ScreenState {
    public var delegate: (any ScreenStateDelegate)?
    public var validator: (any Validator)!
    
    //некорректные вьюшки и подписи для них
    private var incorrectDataLabels: [UIView: UIView] = [:]
    
    var titleLabel = UILabel()
    var nextButton = UIButton.ftFilled(title: "Далее")
    
    public override init() {
        super.init()
        setupViews()
    }
    
    public func viewsToPresent() -> [UIView] {
        return []
    }
    
    //MARK: - UI
    //Override
    internal func setupViews() {
        setupTitleLabel()
        setupNextButton()
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
    
    //MARK: - Actions
    internal func nextButtonPressed(_ action: UIAction?) {
        if validateValues() {
            delegate?.screenStateGoNext(self)
        }
    }

    public func setNextButtonBusy(_ busy: Bool) {
        nextButton.configuration?.showsActivityIndicator = !busy
        nextButton.isEnabled = busy
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
                delegate?.screenState(self, needRemoveView: label)
            }
        }
        //чтобы не добавлять второй раз и при пустом
        else if incorrectDataLabels[field] == nil, let incorrectMessage {
            let label = UILabel.incorrectData(incorrectMessage)
            delegate?.screenState(self, needInertView: label, after: field)
            incorrectDataLabels[field] = label
        }
        
        return isValid
    }
}
