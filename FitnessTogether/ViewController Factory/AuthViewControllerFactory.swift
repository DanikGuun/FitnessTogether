
import UIKit

public protocol AuthViewControllerFactory {
    func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController
    func makeRegistrationVC(delegate: RegistrationViewControllerDelegate?) -> UIViewController
    func makeLoginVC(delegate: LoginViewControllerDelegate?) -> UIViewController
}

public final class BaseAuthViewControllerFactory: AuthViewControllerFactory {
    
    let ftManager: any FTManager = FTManagerAPI()
    
    public func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController {
        let vc = AuthViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeRegistrationVC(delegate: RegistrationViewControllerDelegate?) -> UIViewController {
        let model = BaseRegistrationModel(userInterface: ftManager.user, validator: BaseValidator(), emailConfirmer: BaseEmailConfirmer())
        let vc = RegistrationViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeLoginVC(delegate: LoginViewControllerDelegate?) -> UIViewController {
        let model = BaseLoginModel(userInterface: ftManager.user)
        let vc = LoginViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
}
