
import UIKit

public final class BaseCoachCoordinator: CoachCoordinator {
    
    public var delegate: (any CoachCoordinatorDelegate)?
    public var currentVC: (UIViewController)? { mainVC.currentViewController }
    public var mainVC: UIViewController { navigationVC }
    public var needAnimate: Bool = true
    
    private var navigationVC: UINavigationController
    private var tabBarVC: UITabBarController
    private let factory: CoachViewControllerFactory
    
    
    init(factory: CoachViewControllerFactory) {
        self.factory = factory
        self.tabBarVC = factory.makeTabBarVC()
        self.navigationVC = UINavigationController(rootViewController: tabBarVC)
        navigationVC.navigationBar.isHidden = true
        tabBarVC.selectedIndex = 1
    }

    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }
    
}
