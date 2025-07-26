
import UIKit

public protocol CoachViewControllerFactory {
    func makeTabBarVC() -> UITabBarController
    func makeMainVC() -> UIViewController
    func makeCalendarVC() -> UIViewController
    func makerWorkoutsVC() -> UIViewController
    func makeProfileVC() -> UIViewController
}

public final class BaseCoachViewControllerFactory: CoachViewControllerFactory {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func makeTabBarVC() -> UITabBarController {
        let tabBarController = UITabBarController()
        
        let tabBar = FTTabBar()
        tabBarController.setValue(tabBar, forKey: "tabBar")
        
        tabBarController.viewControllers = [
            makeMainVC(),
            makeCalendarVC(),
            makerWorkoutsVC(),
            makeProfileVC()
        ]
        
        return tabBarController
    }
    
    public func makeMainVC() -> UIViewController {
        let model = CoachMainModel(ftManager: ftManager)
        let vc = CoachMainViewController(model: model)
        vc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "house"), selectedImage: UIImage(named: "house.fill"))
        return vc
    }
    
    public func makeCalendarVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Календарь", image: UIImage(named: "calendar"), selectedImage: UIImage(named: "calendar.fill"))
        return vc
    }
    
    public func makerWorkoutsVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(named: "barbell"), selectedImage: UIImage(named: "barbell.fill"))
        return vc
    }
    
    public func makeProfileVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "figure"), selectedImage: UIImage(named: "figure.fill"))
        return vc
    }
    
    
}
