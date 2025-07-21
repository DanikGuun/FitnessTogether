
import UIKit

public extension UIView {
    
    var viewController: UIViewController? {
        var responder: UIResponder = self
        while let next = responder.next {
            if let vc = responder as? UIViewController { return vc }
            responder = next
        }
        return nil
    }
    
    func constraintHeight(_ height: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    static func spaceView(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.constraintHeight(height)
        return view
    }
}
