
import UIKit

public protocol AuthViewControllerFactory {
    func makeAuthVC(delegate: (any AuthViewControllerDelegate)?) -> UIViewController
    func makeRegistrationVC(delegate: (any RegistrationViewControllerDelegate)?) -> UIViewController
    func makeLoginVC(delegate: (any LoginViewControllerDelegate)?) -> UIViewController
    func makePasswordRecoveryVC(delegate: (any PasswordRecoverControllerDelegate)?) -> UIViewController
}

public final class BaseAuthViewControllerFactory: AuthViewControllerFactory {
    
    let ftManager: any FTManager
    
    private let validator = BaseValidator()
    private let emailConfirmer = BaseEmailConfirmer()
    
    init(ftManager: any FTManager) {
        self.ftManager = ftManager
    }
    
    public func makeAuthVC(delegate: (any AuthViewControllerDelegate)?) -> UIViewController {
        let vc = AuthViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeRegistrationVC(delegate: (any RegistrationViewControllerDelegate)?) -> UIViewController {
        let model = BaseRegistrationModel(userInterface: ftManager.user, validator: validator, emailConfirmer: emailConfirmer)
        let vc = RegistrationViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeLoginVC(delegate: (any LoginViewControllerDelegate)?) -> UIViewController {
        let model = BaseLoginModel(userInterface: ftManager.user)
        let vc = LoginViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makePasswordRecoveryVC(delegate: (any PasswordRecoverControllerDelegate)?) -> UIViewController {
        let model = BasePasswordRecoverModel(ftManager: ftManager, validator: validator)
        let vc = PasswordRecoverViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
}
