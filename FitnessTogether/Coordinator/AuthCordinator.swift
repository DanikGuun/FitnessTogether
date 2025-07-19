
import UIKit

public final class AuthCoordinator: NSObject, Coordinator {

    public var currentVC: UIViewController? { getCurrnetVC(base: window.rootViewController) }
    public var mainVC: UIViewController { navigationVC }
    
    private var navigationVC: UINavigationController!
    private let factory: AuthViewControllerFactory
    private let window: UIWindow
    
    init(window: UIWindow, factory: AuthViewControllerFactory) {
        self.factory = factory
        self.window = window
        self.navigationVC = nil
        super.init()
        let startVC = factory.makeAuthVC(delegate: self)
        self.navigationVC = UINavigationController(rootViewController: startVC)
    }
    
    
    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: true)
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

extension AuthCoordinator: AuthViewControllerDelegate {
    public func authViewControllerGoToLogin(authViewController: AuthViewController) {
        print("login")
    }
    public func authViewControllerGoToRegister(authViewController: AuthViewController) {
        print( "register")
    }
}
