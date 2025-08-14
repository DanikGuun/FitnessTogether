
import UIKit

public final class BaseCoachCoordinator: NSObject, CoachCoordinator {
    
    public var delegate: (any CoachCoordinatorDelegate)?
    public var currentVC: (UIViewController)? { mainVC.currentViewController }
    public var mainVC: UIViewController { navigationVC }
    public var needAnimate: Bool = true
    
    private var navigationVC: UINavigationController!
    private var tabBarVC: UITabBarController!
    private let factory: CoachViewControllerFactory
    
    
    init(factory: CoachViewControllerFactory) {
        self.factory = factory
        super.init()
        self.tabBarVC = factory.makeTabBarVC(calendarDelegate: self)
        self.navigationVC = UINavigationController(rootViewController: tabBarVC)
        tabBarVC.selectedIndex = 1
        
        //TODO: - Remove
        calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
    }

    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }
    
}

extension BaseCoachCoordinator: CalendarViewControllerDelegate {
    
    public func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?) {
        let vc = factory.makeAddWorkoutVC(startInterval: interval)
        show(vc)
    }
    
}
