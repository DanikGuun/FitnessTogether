
import UIKit

public protocol CoachViewControllerFactory {
    func makeTabBarVC(calendarDelegate: CalendarViewControllerDelegate?) -> UITabBarController
    func makeMainVC() -> UIViewController
    func makeCalendarVC(delegate: CalendarViewControllerDelegate?) -> UIViewController
    func makeWorkoutsVC() -> UIViewController
    func makeProfileVC() -> UIViewController
    func makeAddWorkoutVC(startInterval: DateInterval?) -> UIViewController
}

public final class BaseCoachViewControllerFactory: CoachViewControllerFactory {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func makeTabBarVC(calendarDelegate: CalendarViewControllerDelegate?) -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let tabBar = FTTabBar()
        tabBarController.setValue(tabBar, forKey: "tabBar")
        
        tabBarController.viewControllers = [
            makeMainVC(),
            makeCalendarVC(delegate: calendarDelegate),
            makeWorkoutsVC(),
            makeProfileVC()
        ]
        
        return tabBarController
    }
    
    public func makeMainVC() -> UIViewController {
        let model = CoachMainModel(ftManager: ftManager)
        let vc = MainWorkoutsViewController(model: model)
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
    
    public func makeAddWorkoutVC(startInterval: DateInterval?) -> UIViewController {
        let model = BaseWorkoutBuilderModel()
        let vc = WorkoutBuilderViewController(model: model)
        return vc
    }
    
    
}
