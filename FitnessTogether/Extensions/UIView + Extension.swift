
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
        self.translatesAutoresizingMaskIntoConstraints = false
        if let constraint = self.constraints.first(where: { $0.identifier == "heightConstraint" }) {
            constraint.constant = height
            updateConstraints()
            superview?.layoutIfNeeded()
            setNeedsDisplay()
        }
        else {
            let constraint = heightAnchor.constraint(equalToConstant: height)
            constraint.identifier = "heightConstraint"
            constraint.isActive = true
        }
    }
    
    static func spaceView(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.constraintHeight(height)
        return view
    }
}
