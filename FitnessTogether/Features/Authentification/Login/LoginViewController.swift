
import UIKit
import OutlineTextField
import FTDomainData

public final class LoginViewController: FTViewController, UITextFieldDelegate {
    
    var model: LoginModel!
    var delegate: LoginViewControllerDelegate?
    
    private let titleLabel = UILabel()
    private let emailTextField = OutlinedTextField.ftTextField(placeholder: "Email")
    private let passwordTextField = OutlinedTextField.ftTextField(placeholder: "Пароль")
    private let passwordVisibilityButton = UIButton(configuration: .plain())
    private let loginButton = UIButton.ftFilled(title: "Войти")
    private let incorrectLabel = UILabel.incorrectData("Неверый Email или пароль")
    private let motivationLabel = UILabel()
    
    //MARK: - Lifecycle
    public convenience init(model: LoginModel!) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Логин"
        setupViews()
    }
    
    //MARK: - UI
    private func setupViews() {
        addSpacing(.fractional(0.12))
        setupTitleLabel()
        setupEmailTextField()
        setupPasswordTextField()
        setupPasswordVisibilityButton()
        setupLoginButton()
        setupRecoverPasswordButton()
        setupMotivationLabel()
    }
    
    private func setupTitleLabel() {
        titleLabel.text = "Заполните поля"
        titleLabel.font = DC.Font.headline
        addStackSubview(titleLabel, spaceAfter: .fixed(25))
    }
    
    private func setupEmailTextField() {
        addStackSubview(emailTextField)
        emailTextField.delegate = self
        emailTextField.autocapitalizationType = .none
        emailTextField.autocorrectionType = .no
    }
    
    private func setupPasswordTextField() {
        passwordTextField.textContentType = .password
        passwordTextField.autocapitalizationType = .none
        passwordTextField.delegate = self
        
        var insets = passwordTextField.activeAppearance.insets
        insets.right = 50
        passwordTextField.standartAppearance.insets = insets
        passwordTextField.activeAppearance.insets = insets
        passwordTextField.errorAppearance.insets = insets
        addStackSubview(passwordTextField)
    }
    
    private func setupPasswordVisibilityButton() {
        passwordTextField.addSubview(passwordVisibilityButton)
        passwordVisibilityButton.snp.makeConstraints { maker in
            maker.top.bottom.trailing.equalToSuperview().inset(DC.Layout.insets.right)
        }
        
        passwordVisibilityButton.changesSelectionAsPrimaryAction = true
        passwordVisibilityButton.configurationUpdateHandler = passwordVisibleButtonConfigurationUpdateHandler
    }
    
    private func passwordVisibleButtonConfigurationUpdateHandler(_ button: UIButton) {
        let imageName = button.isSelected ? "eye.striked" : "eye"
        let superTextFieldIsEdiding = (button.superview as? OutlinedTextField)?.isActiveState ?? false
        var conf = button.configuration
        conf?.image = UIImage(named: imageName)
        conf?.baseForegroundColor = superTextFieldIsEdiding ? .label : .systemGray4
        conf?.baseBackgroundColor = .clear
        button.configuration = conf
    }
    
    private func setupLoginButton () {
        addStackSubview(loginButton)
        loginButton.isEnabled = false
        loginButton.addAction(UIAction(handler: onLoginButtonPressed), for: .touchUpInside)
    }
    
    public func checkLoginButtonEnabled() {
        loginButton.isEnabled = !(emailTextField.text?.isEmpty ?? true || passwordTextField.text?.isEmpty ?? true)
    }
    
    private func setLoginButtonBusy(_ busy: Bool) {
        loginButton.configuration?.showsActivityIndicator = busy
        loginButton.isEnabled = busy
    }
    
    private func setupRecoverPasswordButton() {
        let button = UIButton.secondaryButton(title: "Забыли пароль?")
        button.addAction(UIAction(handler: { [weak self] _ in
            guard let self else { return }
            self.delegate?.loginViewControllerGoToRecoverPassword(self)
        }), for: .touchUpInside)
        
        addStackSubview(button, height: 20)
    }
    
    private func setupMotivationLabel() {
        view.addSubview(motivationLabel)
        motivationLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(75)
        }
        
        motivationLabel.font = DC.Font.roboto(weight: .regular, size: 15)
        motivationLabel.textColor = .secondaryLabel
        motivationLabel.text = model.motivationTitles.randomElement()
    }
    
    //MARK: - TextField Delegate

    public func textFieldDidBeginEditing(_ textField: UITextField) {
        passwordVisibilityButton.setNeedsUpdateConfiguration()
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        passwordVisibilityButton.setNeedsUpdateConfiguration()
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        showIncorrectLabel(false)
        checkLoginButtonEnabled()
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            let _ = passwordTextField.becomeFirstResponder()
        }
        else if textField == passwordTextField {
            let _ = passwordTextField.resignFirstResponder()
            onLoginButtonPressed(nil)
        }
        return true
    }
    
    //MARK: - Other
    private func onLoginButtonPressed(_ action: UIAction?) {
        setLoginButtonBusy(true)
        
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let userLogin = FTUserLogin(email: email, password: password)
        
        model.login(userLogin: userLogin, completion: { [weak self] result in
            guard let self else { return }
            setLoginButtonBusy(false)
            
            if case .success = result {
                delegate?.loginViewControllerDidLogin(self)
            }
            else {
                showIncorrectLabel(true)
            }
        })
    }
    
    private func showIncorrectLabel(_ show: Bool) {
        if show {
            let index = self.stackView.arrangedSubviews.firstIndex(of: titleLabel) ?? 0
            stackView.insertArrangedSubview(incorrectLabel, at: index + 1)
        }
        else {
            stackView.removeArrangedSubview(incorrectLabel)
            incorrectLabel.removeFromSuperview()
        }
    }
}

public protocol LoginViewControllerDelegate {
    func loginViewControllerGoToRecoverPassword(_ loginViewController: UIViewController)
    func loginViewControllerDidLogin(_ loginViewController: UIViewController)
}

public extension LoginViewControllerDelegate {
    func loginViewControllerGoToRecoverPassword(_ loginViewController: UIViewController) {}
    func loginViewControllerDidLogin(_ loginViewController: UIViewController) {}
}
