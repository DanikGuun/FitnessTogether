
import UIKit
import FTDomainData

public final class RegistrationRoleState: BaseRegistrationState {
    
    var subtitleLabel = UILabel()
    var coachButton = UIButton.ftPlain(title: "Тренер")
    var clientButton = UIButton.ftPlain(title: "Клиент")
    
    private var buttons: [UIButton] { return [coachButton, clientButton] }
    
    override init() {
        
    }
    
    public override func viewsToPresent() -> [UIView] {
        return [titleLabel, subtitleLabel, UIView.spaceView(20), coachButton, clientButton, nextButton]
    }
    
    public override func apply(userRegister: inout FTUserRegister) {
        if coachButton.isSelected { userRegister.role = .coach }
        else if clientButton.isSelected { userRegister.role = .client }
    }
    
    //MARK: - UI
    override func setupViews() {
        super.setupViews()
        setupSubtitleLabel()
        setupRoleButton(coachButton)
        setupRoleButton(clientButton)
    }
    
    override func setupTitleLabel() {
        super.setupTitleLabel()
        titleLabel.text = "Выберите роль"
    }
    
    private func setupSubtitleLabel() {
        subtitleLabel.text = "Выберите для себя одну из представленных ниже ролей. Тренер - и так далее поясняющий текст"
        subtitleLabel.font = DC.Font.roboto(weight: .regular, size: 15)
        subtitleLabel.textColor = .systemGray3
        subtitleLabel.numberOfLines = 0
    }
    
    private func setupRoleButton(_ button: UIButton) {
        button.changesSelectionAsPrimaryAction = true
        button.configurationUpdateHandler = buttonUpdateHandler
        button.addAction(UIAction(handler: roleButtonPressed), for: .touchUpInside)
    }
    private func buttonUpdateHandler(_ button: UIButton) {
        var conf = button.configuration
        conf?.background.strokeColor = button.isSelected ? .ftOrange : .systemGray3
        conf?.baseForegroundColor = button.isSelected ? .ftOrange : .label
        conf?.baseBackgroundColor = .clear
        button.configuration = conf
    }
    
    private func roleButtonPressed(_ action: UIAction) {
        guard let buttonSender = action.sender as? UIButton else { return }
        for button in buttons {
            button.isSelected = button === buttonSender
        }
        checkNextButtonAvailable(nil)
    }
    
    //MARK: - Validation
    override func isAllFieldsFilled() -> Bool {
        return coachButton.isSelected || clientButton.isSelected
    }
    
    override func validateValues() -> Bool {
        return coachButton.isSelected || clientButton.isSelected
    }
    
}
