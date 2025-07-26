
import UIKit

public extension UIViewController {
    
    var isOverlapsed: Bool {
        guard let vc = self.presentedViewController else { return false }
        return !vc.isBeingDismissed
    }
    
    var currentViewController: UIViewController {
        return getCurrentVC(base: self)!
    }
    
    private func getCurrentVC(base: UIViewController?) -> (UIViewController)? {
        if let nav = base as? UINavigationController {
            return getCurrentVC(base: nav.viewControllers.last)
        }
        if let tab = base as? UITabBarController {
            return getCurrentVC(base: tab.selectedViewController)
        }
        if let presented = base?.presentedViewController {
            return getCurrentVC(base: presented)
        }
        return base
    }
    
}
