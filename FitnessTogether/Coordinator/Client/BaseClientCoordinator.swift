import UIKit

public final class BaseClientCoordinator: NSObject, ClientCoordinator {
    
    public var delegate: (any ClientCoordinatorDelegate)?
    public var currentVC: (UIViewController)? { mainVC.currentViewController }
    public var mainVC: UIViewController { navigationVC }
    public var needAnimate: Bool = true
    
    private var navigationVC: UINavigationController!
    private var tabBarVC: UITabBarController!
    private let factory: ClientViewControllerFactory
    
    
    init(factory: ClientViewControllerFactory) {
        self.factory = factory
        super.init()
        self.tabBarVC = factory.makeTabBarVC(workoutListDeleage: self, profileDelegate: self)
        self.navigationVC = UINavigationController(rootViewController: tabBarVC)
    }

    public func show(_ viewController: UIViewController) {
        navigationVC.pushViewController(viewController, animated: needAnimate)
    }
    
}

extension BaseClientCoordinator: WorkoutListViewControllerDelegate {
    
    public func workoutListVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String) {
        let vc = factory.makeEditWorkoutVC(workoutId: workoutId, delegate: self)
        show(vc)
    }
    
    public func workoutListRequestToOpenFilter(_ vc: UIViewController, delegate: (any WorkoutFilterViewControllerDelegate)?) {
        let vc = factory.makeFilterVC(delegate: delegate)
        currentVC?.present(vc, animated: true)
    }
    
}

extension BaseClientCoordinator: WorkoutViewerViewControllerDelegate {
    
    public func workoutViewerVC(_ vc: WorkoutViewerViewController, requestToShowExerciseWith exerciseId: String, workoutId: String) {
        let vc = factory.makeEditExerciseVC(workoutId: workoutId, exerciseId: exerciseId, delegate: self)
        show(vc)
    }
    
}

extension BaseClientCoordinator: ExerciseBuilderViewControllerDelegate {
    
    public func exerciseBuilderVCGoToSetList(_ vc: UIViewController, exerciseId: String) {
        let vc = factory.makeSetListVC(exerciseId: exerciseId, delegate: self)
        show(vc)
    }
    
}

extension BaseClientCoordinator: ProfileViewControllerDelegate {
    
    public func profileVCRequestToAddClient(_ vc: UIViewController, delegate: (any AddClientViewControllerDelegate)?) {
        let vc = factory.makeAddToCoachVC()
        vc.modalPresentationStyle = .formSheet
        vc.preferredContentSize = CGSize(width: 350, height: 400)
        let customDetent = UISheetPresentationController.Detent.custom(resolver: { _ in
            return 250
        })
        vc.sheetPresentationController?.detents = [customDetent]
        currentVC?.present(vc, animated: needAnimate)
    }
    
    public func profileVCDeleteAccount(_ vc: UIViewController) {
        delegate?.clientCoordinatorShouldGoToLogin(self)
    }
    
}

extension BaseClientCoordinator: SetListViewControllerDelegate {
    
    public func setListVCDidFinish(_ vc: UIViewController) {
        navigationVC.popViewController(animated: needAnimate)
    }
    
}
