
import UIKit
import FTDomainData

public protocol RegistrationState: ScreenState, AnyObject {
    func apply(userRegister: inout FTUserRegister)
    func setNextButtonBusy(_ available: Bool)
    func setEmptyState()
}

open class BaseRegistrationState: BaseFieldsScreenState, RegistrationState {
  
    var infoLabel = UILabel()

    //override
    public func apply(userRegister: inout FTUserRegister) {
    }
    
    //override
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, nextButton, infoLabel]
    }
    
    //MARK: - UI
    //Override
    internal override func setupViews() {
        super.setupViews()
        setupInfoLabel()
    }
    
    internal func setupInfoLabel() {
        infoLabel.text = "Регистрируясь, вы соглашаетесь с условиями\nиспользования приложения и политикой конфиденциальности"
        infoLabel.textColor = .systemGray4
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = DC.Font.additionalInfo
    }
    
    public func setEmptyState() {}

}
