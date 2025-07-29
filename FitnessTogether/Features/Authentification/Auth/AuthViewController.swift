
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
            self.delegate?.authViewControllerGoToRegister(self)
        }), for: .touchUpInside)
        addStackSubview(button, height: DC.Size.buttonHeight)
    }
    
    private func setupLoginButton() {
        let button = UIButton.ftPlain(title: "Войти")
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.authViewControllerGoToLogin(self)
        }), for: .touchUpInside)
        addStackSubview(button, height: DC.Size.buttonHeight)
    }
    
}

public protocol AuthViewControllerDelegate {
    func authViewControllerGoToRegister(_ authViewController: UIViewController)
    func authViewControllerGoToLogin(_ authViewController: UIViewController)
}

extension AuthViewControllerDelegate {
    public func authViewControllerGoToRegister(_ authViewController: UIViewController) {}
    public func authViewControllerGoToLogin(_ authViewController: UIViewController) {}
}
