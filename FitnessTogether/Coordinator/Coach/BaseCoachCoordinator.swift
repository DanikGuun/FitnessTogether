
import UIKit
import FTDomainData

public final class BaseCoachCoordinator: NSObject, CoachCoordinator {
    
    public var delegate: (any CoachCoordinatorDelegate)?
    public var currentVC: (UIViewController)? { mainVC.currentViewController }
    public var mainVC: UIViewController { navigationVC }
    public var needAnimate: Bool = true
    
    private var navigationVC: UINavigationController!
    var tabBarVC: UITabBarController!
    private let factory: CoachViewControllerFactory
    
    
    init(factory: CoachViewControllerFactory) {
        self.factory = factory
        super.init()
        self.tabBarVC = factory.makeTabBarVC(workoutListDeleage: self, calendarDelegate: self, profileDelegate: self)
        self.navigationVC = UINavigationController(rootViewController: tabBarVC)
        tabBarVC.selectedIndex = 0

    }

    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }
    
}

extension BaseCoachCoordinator: WorkoutListViewControllerDelegate {
    
    public func workoutListVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String) {
        let vc = factory.makeEditWorkoutVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
    public func workoutListRequestToOpenAddWorkout(_ vc: UIViewController) {
        let vc = factory.makeAddWorkoutVC(startInterval: nil, delegate: self)
        show(vc)
    }
    
    public func workoutListRequestToOpenFilter(_ vc: UIViewController, delegate: (any WorkoutFilterViewControllerDelegate)?) {
        let vc = factory.makeFilterVC(delegate: delegate)
        currentVC?.present(vc, animated: needAnimate)
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
        factory.changeWorkoutBuilderToEditModel(vc)
        let vc = factory.makeExerciseListVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: ExerciseListViewControllerDelegate {
    
    public func exerciseListVCDidFinish(_ vc: UIViewController) {
        navigationVC.popToViewController(tabBarVC, animated: needAnimate)
    }
    
    public func exerciseListVCrequestToOpenAddExerciseVC(_ vc: UIViewController, workoutId: String) {
        let vc = factory.makeCreateExerciseVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
    public func exerciseListVCrequestToOpenEditExerciseVC(_ vc: UIViewController, workoutId: String, exerciseId: String) {
        let vc = factory.makeEditExerciseVC(workoutId: workoutId, exerciseId: exerciseId, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: ExerciseBuilderViewControllerDelegate {
    
    public func exerciseBuilderVCDidFinish(_ vc: UIViewController) {
        navigationVC.popViewController(animated: needAnimate)
    }
    
    public func exerciseBuilderVCGoToSetList(_ vc: UIViewController, exerciseId: String) {
        factory.changeExerciseBuilderToEditModel(vc)
        let vc = factory.makeSetListVC(exerciseId: exerciseId, delegate: self)
        show(vc)
    }
    
}

extension BaseCoachCoordinator: SetListViewControllerDelegate {
    
    public func setListVCDidFinish(_ vc: UIViewController) {
        navigationVC.popViewController(animated: needAnimate)
    }
    
    public func setListVCRequestToOpenAddSetVC(_ vc: UIViewController, exerciseId: String) {
        print("Add to id: \(exerciseId)")
    }
    
    public func setListVCRequestToOpenEditSetVC(_ vc: UIViewController, setId: String, exerciseId: String) {
        print("Edit \(setId) to id: \(exerciseId)")
    }
    
}

extension BaseCoachCoordinator: ProfileViewControllerDelegate {
    
    public func profileVCRequestToAddClient(_ vc: UIViewController, delegate: (any AddClientViewControllerDelegate)?) {
        let vc = factory.makeAddClientVC(delegate: delegate)
        vc.modalPresentationStyle = .formSheet
        vc.preferredContentSize = CGSize(width: 350, height: 400)
        vc.sheetPresentationController?.detents = [.medium()]
        currentVC?.present(vc, animated: needAnimate)
    }
    
}
