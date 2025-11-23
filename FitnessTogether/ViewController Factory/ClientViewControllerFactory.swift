
import UIKit

public protocol ClientViewControllerFactory {
    func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, profileDelegate: (any ProfileViewControllerDelegate)?) -> UITabBarController
    func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController
//    func makeWorkoutsVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController
//    func makeProfileVC(delegate: (any ProfileViewControllerDelegate)?) -> UIViewController
    func makeEditWorkoutVC(workoutId: String, delegate: (any WorkoutViewerViewControllerDelegate)?) -> UIViewController
//    func changeWorkoutBuilderToEditModel(_ vc: UIViewController)
//    func makeExerciseListVC(workoutId: String, delegate: (any ExerciseListViewControllerDelegate)?) -> UIViewController
//    func makeCreateExerciseVC(workoutId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController
//    func changeExerciseBuilderToEditModel(_ vc: UIViewController)
    func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController
    func makeFilterVC(delegate: (any WorkoutFilterViewControllerDelegate)?) -> UIViewController
    func makeSetListVC(exerciseId: String, delegate: (any SetListViewControllerDelegate)) -> UIViewController
    func makeAddToCoachVC() -> UIViewController
}

public class BaseClientViewControllerFactory: ClientViewControllerFactory {
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, profileDelegate: (any ProfileViewControllerDelegate)?) -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let tabBar = FTTabBar()
        tabBarController.setValue(tabBar, forKey: "tabBar")
        
        tabBarController.viewControllers = [
            makeMainVC(delegate: workoutListDeleage),
            makeWorkoutsVC(delegate: workoutListDeleage),
            makeProfileVC(delegate: profileDelegate)
        ]
        
        return tabBarController
    }
    
    public func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController {
        let model = ClientWorkoutListModel(ftManager: ftManager)
        let bag = FTFilterBag(dateInterval: .custom(getThisWeekInterval()))
        model.initialFilterBag = bag
        model.currentFilterBag = bag
        
        let vc = WorkoutListViewController(model: model)
        vc.delegate = delegate
        vc.filterButton.isHidden = true
        vc.addWorkoutButton.removeFromSuperview()
        vc.stackView.removeArrangedSubview(vc.addWorkoutButton)
        vc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "House"), selectedImage: UIImage(named: "House.fill"))
        
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
        vc.addWorkoutButton.removeFromSuperview()
        vc.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(named: "Barbell"), selectedImage: UIImage(named: "Barbell.fill"))
        return vc
    }
    
    public func makeProfileVC(delegate: (any ProfileViewControllerDelegate)?) -> UIViewController {
        let model = BaseProfileModel(ftManager: ftManager)
        let vc = ProfileViewController(model: model)
        vc.delegate = delegate
        vc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "Figure"), selectedImage: UIImage(named: "Figure.fill"))
        
        let attributes = AttributeContainer([
            .font: DC.Font.roboto(weight: .semibold, size: 16)
        ])
        vc.addClientButton.configuration?.attributedTitle = AttributedString("Добавить тренера", attributes: attributes)
        
        vc.stackView.removeArrangedSubview(vc.clientCollection)
        vc.clientCollection.removeFromSuperview()
        
        vc.stackView.removeArrangedSubview(vc.clientsTitleLabel)
        vc.clientsTitleLabel.removeFromSuperview()
        
        vc.stackView.removeArrangedSubview(vc.clientDisclosureButton)
        vc.clientDisclosureButton.removeFromSuperview()
        return vc
    }
    
    public func makeEditWorkoutVC(workoutId: String, delegate: (any WorkoutViewerViewControllerDelegate)?) -> UIViewController {
        let model = BaseWorkoutViewerModel(workoutId: workoutId, ftManager: ftManager)
        let vc = WorkoutViewerViewController(model: model)
        vc.delegate = delegate        
        return vc
    }
    
    public func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        let model = ExerciseBuilderEditModel(ftManager: ftManager, workoutId: workoutId, exerciseId: exerciseId)
        let vc = ExerciseBuilderViewController(model: model)
        vc.delegate = delegate
        
        vc.nameTextField.isUserInteractionEnabled = false
        vc.descriptionTextView.isUserInteractionEnabled = false
        vc.muscleKindSelecter.isSelectingEnable = false
        vc.complexitySlider.isUserInteractionEnabled = false
        vc.addExerciseButton.removeFromSuperview()
        
        return vc
    }
    
    public func makeSetListVC(exerciseId: String, delegate: (any SetListViewControllerDelegate)) -> UIViewController {
        let model = BaseSetListModel(ftManager: ftManager, exerciseId: exerciseId)
        let vc = SetListViewController(model: model)
        vc.delegate = delegate
        return vc
    }
    
    public func makeFilterVC(delegate: (any WorkoutFilterViewControllerDelegate)?) -> UIViewController {
        let vc = WorkoutFilterViewController()
        vc.delegate = delegate
        return vc
    }
    
    public func makeAddToCoachVC() -> UIViewController {
        let model = BaseAddToCoachModel(ftManager: ftManager)
        let vc = AddToCoachViewController(model: model)
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

