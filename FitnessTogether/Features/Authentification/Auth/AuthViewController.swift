
import UIKit

public final class AuthViewController: FTViewController {
    
    var delegate: AuthViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        isScrollEnable = false
    }
    
    private func setupUI() {
        setupLabel()
        addSpacing(.fractional(0.66))
        setupRegistrationButton()
        setupLoginButton()
        setupRecoverPasswordButton()
    }
    
    private func setupLabel() {
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalToSuperview().dividedBy(1.4)
        }
        
        var string = AttributedString("Fitness Together")
        string.font = DC.Font.roboto(weight: .semibold, size: 32)
        string.foregroundColor = .label
        let togetherRange = string.range(of: "Together")!
        string[togetherRange].foregroundColor = UIColor.ftOrange
        label.attributedText = NSAttributedString(string)
    }
    
    private func setupRegistrationButton() {
        let button = UIButton.ftFilled(title: "Зарегистрироваться")
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.authViewControllerGoToRegister(authViewController: self)
        }), for: .touchUpInside)
        addStackSubview(button, height: DC.Size.buttonHeight)
    }
    
    private func setupLoginButton() {
        let button = UIButton.ftPlain(title: "Войти")
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.authViewControllerGoToLogin(authViewController: self)
        }), for: .touchUpInside)
        addStackSubview(button, height: DC.Size.buttonHeight)
    }
    
    private func setupRecoverPasswordButton() {
        
        let attrs = AttributeContainer([
            .font : DC.Font.additionalInfo,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemGray
        ])
        let title = AttributedString("Забыли пароль?", attributes: attrs)
        
        let button = UIButton(configuration: .plain())
        button.configuration?.attributedTitle = title
        
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.authViewControllerGoToRecoverPassword(authViewController: self)
        }), for: .touchUpInside)
        addStackSubview(button, height: 20)
    }
    
}

public protocol AuthViewControllerDelegate {
    func authViewControllerGoToRegister(authViewController: UIViewController)
    func authViewControllerGoToLogin(authViewController: UIViewController)
    func authViewControllerGoToRecoverPassword(authViewController: UIViewController)
}

extension AuthViewControllerDelegate {
    public func authViewControllerGoToRegister(authViewController: UIViewController) {}
    public func authViewControllerGoToLogin(authViewController: UIViewController) {}
    public func authViewControllerGoToRecoverPassword(authViewController: UIViewController) {}
}
