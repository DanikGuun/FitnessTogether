
import UIKit
import FTDomainData

public protocol CoachViewControllerFactory {
    func makeTabBarVC(mainDeleage: (any MainViewControllerDelegate)?, calendarDelegate: CalendarViewControllerDelegate?) -> UITabBarController
    func makeMainVC(delegate: (any MainViewControllerDelegate)?) -> UIViewController
    func makeCalendarVC(delegate: CalendarViewControllerDelegate?) -> UIViewController
    func makeWorkoutsVC() -> UIViewController
    func makeProfileVC() -> UIViewController
    func makeAddWorkoutVC(startInterval: DateInterval?, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController
    func makeEditWorkoutVC(workoutId: String, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController
    func changeWorkoutBuilderToEditModel(_ vc: UIViewController, workoutId: String)
    func makeExerciseListVC(workoutId: String, delegate: (any ExerciseListViewControllerDelegate)?) -> UIViewController
    func makeCreateExerciseVC(workoutId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController
    func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController
}

public final class BaseCoachViewControllerFactory: CoachViewControllerFactory {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func makeTabBarVC(mainDeleage: (any MainViewControllerDelegate)?, calendarDelegate: CalendarViewControllerDelegate?) -> UITabBarController {
        let tabBarController = FTTabBarController()
        
        let tabBar = FTTabBar()
        tabBarController.setValue(tabBar, forKey: "tabBar")
        
        tabBarController.viewControllers = [
            makeMainVC(delegate: mainDeleage),
            makeCalendarVC(delegate: calendarDelegate),
            makeWorkoutsVC(),
            makeProfileVC()
        ]
        
        return tabBarController
    }
    
    public func makeMainVC(delegate: (any MainViewControllerDelegate)?) -> UIViewController {
        let model = CoachWorkoutListModel(ftManager: ftManager)
        let vc = MainWorkoutsViewController(model: model)
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "house"), selectedImage: UIImage(named: "house.fill"))
        return vc
    }
    
    public func makeCalendarVC(delegate: CalendarViewControllerDelegate?) -> UIViewController {
        let model = CoachCalendarModel(ftManager: ftManager)
        let vc = CalendarViewController(model: model)
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Календарь", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar.fill"))
        return vc
    }
    
    public func makeWorkoutsVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(named: "barbell"), selectedImage: UIImage(named: "barbell.fill"))
        return vc
    }
    
    public func makeProfileVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "figure"), selectedImage: UIImage(named: "figure.fill"))
        return vc
    }
    
    public func makeAddWorkoutVC(startInterval: DateInterval?, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController {
        let model = CreateWorkoutBuilderModel(ftManager: ftManager)
        let vc = WorkoutBuilderViewController(model: model)
        vc.delegate = delegate
        if let date = startInterval?.start { vc.dateTimeView.date = date }
        return vc
    }
    
    public func changeWorkoutBuilderToEditModel(_ vc: UIViewController, workoutId: String) {
        if let vc = vc as? WorkoutBuilderViewController {
            vc.model = vc.model as? EditWorkoutBuilderModel ?? EditWorkoutBuilderModel(ftManager: ftManager, workoutId: workoutId)
        }
    }
    
    public func makeEditWorkoutVC(workoutId: String, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController {
        let model = EditWorkoutBuilderModel(ftManager: ftManager, workoutId: workoutId)
        let vc = WorkoutBuilderViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeExerciseListVC(workoutId: String, delegate: (any ExerciseListViewControllerDelegate)?) -> UIViewController {
        let model = BaseExerciseModel(ftManager: ftManager, workoutId: workoutId)
        let vc = ExerciseListViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeCreateExerciseVC(workoutId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        let model = ExerciseBuilderCreateModel(ftManager: ftManager, workoutId: workoutId)
        let vc = ExerciseBuilderViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        let model = ExerciseBuilderEditModel(ftManager: ftManager, workoutId: workoutId, exerciseId: exerciseId)
        let vc = ExerciseBuilderViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
}
