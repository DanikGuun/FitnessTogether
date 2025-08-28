
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
        let model = ClientWorkoutListModel(ftManager: ftManager)
        let bag = FTFilterBag(dateInterval: .custom(getThisWeekInterval()))
        model.initialFilterBag = bag
        model.currentFilterBag = bag
        
        let vc = WorkoutListViewController(model: model)
        vc.filterButton.isHidden = true
        vc.tabBarItem = UITabBarItem(title: "Главная", image: UIImage(named: "house"), selectedImage: UIImage(named: "house.fill"))
        return vc
    }
    
    public func makerWorkoutsVC() -> UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "Тренировки", image: UIImage(named: "barbell"), selectedImage: UIImage(named: "barbell.fill"))
        return vc
    }
    
    public func makeProfileVC() -> UIViewController {
        let model = BaseProfileModel(ftManager: ftManager)
        let vc = ProfileViewController(model: model)
        vc.tabBarItem = UITabBarItem(title: "Профиль", image: UIImage(named: "figure"), selectedImage: UIImage(named: "figure.fill"))
        vc.clientCollection.removeFromSuperview()
        vc.clientsTitleLabel.removeFromSuperview()
        vc.clientDisclosureButton.removeFromSuperview()
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
