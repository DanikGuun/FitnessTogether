
import UIKit
import FTDomainData

public protocol CoachViewControllerFactory {
    func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, calendarDelegate: CalendarViewControllerDelegate?, profileDelegate: (any ProfileViewControllerDelegate)?) -> UITabBarController
    func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController
    func makeCalendarVC(delegate: CalendarViewControllerDelegate?) -> UIViewController
    func makeWorkoutsVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController
    func makeProfileVC(delegate: (any ProfileViewControllerDelegate)?) -> UIViewController
    func makeAddWorkoutVC(startInterval: DateInterval?, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController
    func makeEditWorkoutVC(workoutId: String, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController
    func changeWorkoutBuilderToEditModel(_ vc: UIViewController)
    func makeExerciseListVC(workoutId: String, delegate: (any ExerciseListViewControllerDelegate)?) -> UIViewController
    func makeCreateExerciseVC(workoutId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController
    func changeExerciseBuilderToEditModel(_ vc: UIViewController)
    func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController
    func makeFilterVC(delegate: (any WorkoutFilterViewControllerDelegate)?) -> UIViewController
    func makeSetListVC(exerciseId: String, delegate: (any SetListViewControllerDelegate)) -> UIViewController
    func makeAddClientVC(delegate: (any AddClientViewControllerDelegate)?) -> UIViewController
}

public final class BaseCoachViewControllerFactory: CoachViewControllerFactory {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    //MARK: - Tab
    public func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, calendarDelegate: CalendarViewControllerDelegate?, profileDelegate: (any ProfileViewControllerDelegate)?) -> UITabBarController {
        let tabBarController = FTTabBarController()
        
        let tabBar = FTTabBar()
        tabBarController.setValue(tabBar, forKey: "tabBar")
        
        tabBarController.viewControllers = [
            makeMainVC(delegate: workoutListDeleage),
            makeCalendarVC(delegate: calendarDelegate),
            makeWorkoutsVC(delegate: workoutListDeleage),
            makeProfileVC(delegate: profileDelegate)
        ]
        
        tabBarController.selectedIndex = 3
        return tabBarController
    }
    
    public func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController {
        let model = CoachWorkoutListModel(ftManager: ftManager)
        let bag = FTFilterBag(dateInterval: .custom(getThisWeekInterval()))
        model.initialFilterBag = bag
        model.currentFilterBag = bag
        
        let vc = WorkoutListViewController(model: model)
        vc.filterButton.isHidden = true
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "House"), selectedImage: UIImage(named: "House.fill"))
        return vc
    }
    
    public func makeCalendarVC(delegate: CalendarViewControllerDelegate?) -> UIViewController {
        let model = CoachCalendarModel(ftManager: ftManager)
        let vc = CalendarViewController(model: model)
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Календарь", image: UIImage(named: "Calendar"), selectedImage: UIImage(named: "Calendar.fill"))
        return vc
    }
    
    public func makeWorkoutsVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController {
        let bag = FTFilterBag(dateInterval: .allTime, workoutKind: nil)
        let model = ClientWorkoutListModel(ftManager: ftManager)
        model.initialFilterBag = bag
        model.currentFilterBag = bag
        
        let vc = WorkoutListViewController(model: model)
        vc.delegate = delegate
        vc.mainTitleLabel.text = "Мои тренировки"
        vc.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(named: "Barbell"), selectedImage: UIImage(named: "Barbell.fill"))
        return vc
    }
    
    public func makeProfileVC(delegate: (any ProfileViewControllerDelegate)?) -> UIViewController {
        let model = BaseProfileModel(ftManager: ftManager)
        let vc = ProfileViewController(model: model)
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "Figure"), selectedImage: UIImage(named: "Figure.fill"))
        return vc
    }
    
    //MARK: - Other
    public func makeAddWorkoutVC(startInterval: DateInterval?, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController {
        let model = CreateWorkoutBuilderModel(ftManager: ftManager)
        let vc = WorkoutBuilderViewController(model: model)
        vc.delegate = delegate
        vc.title = "Новая тренировка"
        vc.nextButtonTitle = "Добавить"
        if let interval = startInterval { vc.dateTimeView.dateInterval = interval }
        return vc
    }
    
    public func changeWorkoutBuilderToEditModel(_ vc: UIViewController) {
        guard let vc = vc as? WorkoutBuilderViewController,
                let workoutId = vc.model.workoutId else { return }
        let model = EditWorkoutBuilderModel(ftManager: ftManager, workoutId: workoutId)
        vc.model = model
        vc.title = "Изменить тренировку"
        vc.nextButtonTitle = "Сохранить"
    }
    
    public func makeEditWorkoutVC(workoutId: String, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController {
        let model = EditWorkoutBuilderModel(ftManager: ftManager, workoutId: workoutId)
        let vc = WorkoutBuilderViewController(model: model)
        vc.delegate = delegate
        vc.title = "Изменить тренировку"
        vc.nextButtonTitle = "Сохранить"
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
        vc.title = "Добавить упражнение"
        return vc
    }
    
    public func changeExerciseBuilderToEditModel(_ vc: UIViewController) {
        guard let vc = vc as? ExerciseBuilderViewController else { return }
        let oldModel = vc.model
        guard let exerciseId = oldModel!.exerciseId else { return }
        let model = ExerciseBuilderEditModel(ftManager: ftManager, workoutId: oldModel!.workoutId, exerciseId: exerciseId)
        vc.model = model
        vc.title = "Изменить упражнение"
    }
    
    public func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        let model = ExerciseBuilderEditModel(ftManager: ftManager, workoutId: workoutId, exerciseId: exerciseId)
        let vc = ExerciseBuilderViewController(model: model)
        vc.delegate = delegate
        vc.title = "Изменить упражнение"
        return vc
    }
    
    public func makeFilterVC(delegate: (any WorkoutFilterViewControllerDelegate)?) -> UIViewController {
        let vc = WorkoutFilterViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeSetListVC(exerciseId: String, delegate: (any SetListViewControllerDelegate)) -> UIViewController {
        let model = BaseSetListModel(ftManager: ftManager, exerciseId: exerciseId)
        let vc = SetListViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeAddClientVC(delegate: (any AddClientViewControllerDelegate)?) -> UIViewController {
        let model = BaseAddClientModel(ftManager: ftManager)
        let vc = AddClientViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    //MARK: - Other
    private func getThisWeekInterval() -> DateInterval {
        var interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
        let end = interval.end
        interval.start = Date().addingTimeInterval(-2 * 3600) //сейчас -2 часа, чтобы прошедшие тренировки не отображались
        interval.end = end
        return interval
    }
}
