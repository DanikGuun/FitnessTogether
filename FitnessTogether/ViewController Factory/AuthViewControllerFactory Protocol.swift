
import UIKit

public protocol AuthViewControllerFactory {
    
    func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController
    func makeRegistrationVC() -> UIViewController
    
}

public final class BaseAuthViewControllerFactory: AuthViewControllerFactory {
    
    public func makeAuthVC(delegate: AuthViewControllerDelegate?) -> UIViewController {
        let vc = AuthViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeRegistrationVC() -> UIViewController {
        return RegistrationViewController()
    }
    
}
