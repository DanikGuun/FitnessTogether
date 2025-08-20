
import UIKit
import FTDomainData

public protocol CoachViewControllerFactory {
    func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, calendarDelegate: CalendarViewControllerDelegate?) -> UITabBarController
    func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController
    func makeCalendarVC(delegate: CalendarViewControllerDelegate?) -> UIViewController
    func makeWorkoutsVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController
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
    
    //MARK: - Tab
    public func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, calendarDelegate: CalendarViewControllerDelegate?) -> UITabBarController {
        let tabBarController = FTTabBarController()
        
        let tabBar = FTTabBar()
        tabBarController.setValue(tabBar, forKey: "tabBar")
        
        tabBarController.viewControllers = [
            makeMainVC(delegate: workoutListDeleage),
            makeCalendarVC(delegate: calendarDelegate),
            makeWorkoutsVC(delegate: workoutListDeleage),
            makeProfileVC()
        ]
        
        return tabBarController
    }
    
    public func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController {
        let model = CoachWorkoutListModel(ftManager: ftManager)
        model.additionalFilter = { workout in
            var interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
            let end = interval.end
            interval.start = Date().addingTimeInterval(-2 * 3600) //сейчас -2 часа, чтобы прошедшие тренировки не отображались
            interval.end = end
            return interval.contains(workout.startDate ?? Date())
        }
        
        let vc = WorkoutListViewController(model: model)
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
    
    public func makeWorkoutsVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController {
        let model = ClientWorkoutListModel(ftManager: ftManager)
        let vc = WorkoutListViewController(model: model)
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(named: "barbell"), selectedImage: UIImage(named: "barbell.fill"))
        return vc
    }
    
    public func makeProfileVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "figure"), selectedImage: UIImage(named: "figure.fill"))
        return vc
    }
    
    //MARK: - Other
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
