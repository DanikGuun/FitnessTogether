
import UIKit

public protocol AuthViewControllerFactory {
    
    func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController
    func makeRegistrationVC(delegate: RegistrationViewControllerDelegate?) -> UIViewController
    func makeLoginVC(delegate: LoginViewControllerDelegate?) -> UIViewController
    
}

public final class BaseAuthViewControllerFactory: AuthViewControllerFactory {
    
    public func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController {
        let vc = AuthViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeRegistrationVC(delegate: RegistrationViewControllerDelegate?) -> UIViewController {
        return RegistrationViewController()
    }
    
    public func makeLoginVC(delegate: LoginViewControllerDelegate?) -> UIViewController {
        return UIViewController()
    }
    
}
