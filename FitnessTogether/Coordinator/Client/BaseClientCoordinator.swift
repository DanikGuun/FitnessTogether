import UIKit

public final class BaseClientCoordinator: ClientCoordinator {
    
    public var delegate: (any ClientCoordinatorDelegate)?
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
    }

    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }
    
}
