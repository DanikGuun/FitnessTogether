
import UIKit
import FTDomainData
import OutlineTextfield

public final class RegistrationPersonalDataState: RegistrationState {
    
    var titleLabel = UILabel()
    var nameTextfield = OutlinedTextfield.ftTextfield(placeholder: "Имя")
    var surnameTextfield = OutlinedTextfield.ftTextfield(placeholder: "Фамилия")
    var datePickerView = FTDatePickerView()
    var nextButton = UIButton.ftFilled(title: "Далее")
    var infoLabel = UILabel()
    
    public init() {
        setupViews()
    }
    
    
    public func viewsToPresent() -> [UIView] {
        return [titleLabel, UIView.spaceView(20), nameTextfield, surnameTextfield, datePickerView, nextButton, infoLabel]
    }
    
    public func apply(user: inout FTUser) {
        user.firstName = nameTextfield.text ?? ""
        user.lastName = surnameTextfield.text ?? ""
    }
    
    private func setupViews() {
        setupTitleLabel()
        nameTextfield.constraintHeight(DC.Size.buttonHeight)
        surnameTextfield.constraintHeight(DC.Size.buttonHeight)
        datePickerView.constraintHeight(DC.Size.buttonHeight)
        nextButton.constraintHeight(DC.Size.buttonHeight)
        setupInfoLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.font = DC.Font.headline
        titleLabel.text = "Заполните данные о себе"
    }
    
    private func setupInfoLabel() {
        infoLabel.text = "Регистрируясь, вы соглашаетесь с условиями\nиспользования приложения и политикой конфиденциальности"
        infoLabel.textColor = .systemGray4
        infoLabel.textAlignment = .center
        infoLabel.numberOfLines = 0
        infoLabel.font = DC.Font.additionalInfo
    }
    
}
