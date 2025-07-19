
import UIKit

public protocol AuthViewControllerFactory {
    
    func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController
    func makeRegistrationVC(delegate: AuthViewControllerDelegate?) -> UIViewController
    func makeLoginVC(delegate: AuthViewControllerDelegate?) -> UIViewController
    
}

public final class BaseAuthViewControllerFactory: AuthViewControllerFactory {
    
    public func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController {
        let vc = AuthViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeRegistrationVC(delegate: AuthViewControllerDelegate?) -> UIViewController {
        return RegistrationViewController()
    }
    
    public func makeLoginVC(delegate: AuthViewControllerDelegate?) -> UIViewController {
        return UIViewController()
    }
    
}
