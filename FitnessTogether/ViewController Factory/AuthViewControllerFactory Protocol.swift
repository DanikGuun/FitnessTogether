
import UIKit

public protocol AuthViewControllerFactory {
    
    func makeRegistrationVC() -> UIViewController
    
}

public final class BaseAuthViewControllerFactory: AuthViewControllerFactory {
    
    public func makeRegistrationVC() -> UIViewController {
        return RegistrationViewController()
    }
    
}
