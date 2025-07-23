
import UIKit

public final class BaseCoachCoordinator: CoachCoordinator {
    
    public var delegate: (any CoachCoordinatorDelegate)?
    public var currentVC: (UIViewController)? { self.getCurrnetVC(base: mainVC) }
    public var mainVC: UIViewController { navigationVC }
    public var needAnimate: Bool = true
    
    private var navigationVC: UINavigationController
    private var tabBarVC: UITabBarController
    
    
    init() {
        self.tabBarVC = UITabBarController()
        self.navigationVC = UINavigationController(rootViewController: tabBarVC)
        setup()
    }
    
    private func setup() {
        
    }
    
    public func show(_ viewController: UIViewController) {
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
