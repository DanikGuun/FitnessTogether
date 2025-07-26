
import UIKit

public protocol ClientViewControllerFactory {
    func makeTabBarVC() -> UITabBarController
    func makeMainVC() -> UIViewController
    func makerWorkoutsVC() -> UIViewController
    func makeProfileVC() -> UIViewController
}

public class BaseClientViewControllerFactory: ClientViewControllerFactory {
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
            makerWorkoutsVC(),
            makeProfileVC()
        ]
        
        return tabBarController
    }
    
    public func makeMainVC() -> UIViewController {
        let model = ClientMainModel(ftManager: ftManager)
        let vc = MainWorkoutsViewController(model: model)
        vc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "house"), selectedImage: UIImage(named: "house.fill"))
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
