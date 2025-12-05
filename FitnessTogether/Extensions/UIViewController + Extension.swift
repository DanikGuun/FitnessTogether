
import UIKit

extension UIViewController: UIPopoverPresentationControllerDelegate {
    
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
    
    func presentPopover(_ controller: UIViewController, size: CGSize, sourceView: UIView?, sourceRect: CGRect? = nil, arrowDirections: UIPopoverArrowDirection = .init()) {
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = size
        
        guard let presentation = controller.popoverPresentationController else { return }
        presentation.permittedArrowDirections = arrowDirections
        presentation.sourceView = sourceView
        presentation.sourceRect = sourceRect ?? sourceView?.bounds ?? .zero
        presentation.delegate = self
        
        self.present(controller, animated: true)
    }
    
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func setupKeyboardHider() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.hideKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}
