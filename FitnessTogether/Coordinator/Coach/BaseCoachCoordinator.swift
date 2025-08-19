
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
    
    public func mainVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String) {
        let vc = factory.makeEditWorkoutVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
    public func mainVCRequestToOpenAddWorkout(_ vc: UIViewController) {
        let vc = factory.makeAddWorkoutVC(startInterval: nil, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: CalendarViewControllerDelegate {
    
    public func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?) {
        let vc = factory.makeAddWorkoutVC(startInterval: interval, delegate: self)
        show(vc)
    }
    
    public func calendarViewControllerGoToEditWorkout(_ viewController: UIViewController, workoutId: String) {
        let vc = factory.makeEditWorkoutVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: WorkoutBuilderViewControllerDelegate {
    
    public func workoutBuilderVCDidFinish(_ vc: UIViewController, withId workoutId: String) {
        factory.changeWorkoutBuilderToEditModel(vc, workoutId: workoutId)
        let vc = factory.makeExerciseListVC(workoutId: workoutId, delegate: self)
        show(vc)
    }

    
}

extension BaseCoachCoordinator: ExerciseListViewControllerDelegate {
    
    public func exerciseListVCDidFinish(_ vc: ExerciseListViewController) {
        navigationVC.popToViewController(tabBarVC, animated: needAnimate)
    }
    
    public func exerciseListVCrequestToOpenAddExerciseVC(_ vc: ExerciseListViewController, workoutId: String) {
        let vc = factory.makeCreateExerciseVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
    public func exerciseListVCrequestToOpenEditExerciseVC(_ vc: ExerciseListViewController, workoutId: String, exerciseId: String) {
        let vc = factory.makeEditExerciseVC(workoutId: workoutId, exerciseId: exerciseId, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: ExerciseBuilderViewControllerDelegate {
    
    public func exerciseBuilderVCDidFinish(_ vc: ExerciseBuilderViewController) {
        navigationVC.popViewController(animated: needAnimate)
    }
    
}
