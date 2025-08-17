
import UIKit
import FTDomainData

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
        self.tabBarVC = factory.makeTabBarVC(mainDeleage: self, calendarDelegate: self)
        self.navigationVC = UINavigationController(rootViewController: tabBarVC)
        tabBarVC.selectedIndex = 0

    }

    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }
    
}

extension BaseCoachCoordinator: MainViewControllerDelegate {
    
    public func mainVC(_ vc: MainWorkoutsViewController, requestToOpen workoutId: String) {
        let vc = factory.makeEditWorkoutVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: CalendarViewControllerDelegate {
    
    public func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?) {
        let vc = factory.makeAddWorkoutVC(startInterval: interval, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: WorkoutBuilderViewControllerDelegate {
    
    public func workoutBuilderVCRequestToOpenAddExerciseScreen(_ vc: UIViewController, delegate: (any ExerciseCreateViewControllerDelegate)?) {
        let vc = factory.makeCreateExerciseVC(delegate: delegate)
        currentVC?.present(vc, animated: needAnimate)
    }
    
    public func workoutBuilderVCDidFinish(_ vc: UIViewController) {
        navigationVC.popViewController(animated: needAnimate)
    }
    
}
