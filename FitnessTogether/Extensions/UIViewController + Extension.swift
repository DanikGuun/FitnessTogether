
import UIKit

public extension UIViewController {
    
    var isOverlapsed: Bool {
        guard let vc = self.presentedViewController else { return false }
        return !vc.isBeingDismissed
    }
    
}
