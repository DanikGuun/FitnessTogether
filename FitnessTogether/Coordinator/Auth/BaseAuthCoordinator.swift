
import UIKit

public final class BaseAuthCoordinator: NSObject, AuthCoordinator {

    public var delegate: (any AuthCoordinatorDelegate)?
    public var currentVC: UIViewController? { getCurrnetVC(base: mainVC) }
    public var mainVC: UIViewController { navigationVC }
    public var needAnimate = true
    
    private var navigationVC: UINavigationController!
    private let factory: AuthViewControllerFactory
    
    init(factory: AuthViewControllerFactory) {
        self.factory = factory
        self.navigationVC = nil
        super.init()
        let startVC = factory.makeAuthVC(delegate: self)
        self.navigationVC = UINavigationController(rootViewController: startVC)
    }
    
    
    public func show(_ viewController: UIViewController) {
        ErrorPresenter.activeController = viewController
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }

    private func getCurrnetVC(base: UIViewController?) -> (UIViewController)? {
        if let nav = base as? UINavigationController {
            return getCurrnetVC(base: nav.viewControllers.last)
        }
        if let tab = base as? UITabBarController {
            return getCurrnetVC(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrnetVC(base: presented)
        }
        return base
    }
    
}

extension BaseAuthCoordinator: AuthViewControllerDelegate {
    
    public func authViewControllerGoToRegister(_ authViewController: UIViewController) {
        let vc = factory.makeRegistrationVC(delegate: self)
        show(vc)
    }
    
    public func authViewControllerGoToLogin(_ authViewController: UIViewController) {
        let vc = factory.makeLoginVC(delegate: self)
        show(vc)
    }

}

extension BaseAuthCoordinator: RegistrationViewControllerDelegate {
    
    public func registrationViewControllerDidFinish(_ controller: UIViewController) {
        delegate?.authCoordinatorDidFinishAuth(self)
    }
    
}

extension BaseAuthCoordinator: LoginViewControllerDelegate {
    
    public func loginViewControllerGoToRecoverPassword(_ loginViewController: UIViewController) {
        let vc = factory.makePasswordRecoveryVC(delegate: self)
        show(vc)
    }
    
    public func loginViewControllerDidLogin(_ loginViewController: UIViewController) {
        delegate?.authCoordinatorDidFinishAuth(self)
    }
    
}

extension BaseAuthCoordinator: PasswordRecoverControllerDelegate {
    
    public func passwordRecoverDidFinish(_ controller: UIViewController) {
        delegate?.authCoordinatorDidFinishAuth(self)
    }
    
}
