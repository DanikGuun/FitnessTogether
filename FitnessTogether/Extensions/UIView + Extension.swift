
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
    
    var scrollSuperview: UIScrollView? {
        var responder: UIResponder = self
        while let next = responder.next {
            if let scroll = responder as? UIScrollView { return scroll }
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
    
    func constraintWidth(_ width: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        if let constraint = self.constraints.first(where: { $0.identifier == "widthConstraint" }) {
            constraint.constant = width
            updateConstraints()
            superview?.layoutIfNeeded()
            setNeedsDisplay()
        }
        else {
            let constraint = heightAnchor.constraint(equalToConstant: width)
            constraint.identifier = "width"
            constraint.isActive = true
        }
    }
        
    func makeCornerAndShadow(radius: CGFloat = 15, shadowRadius: CGFloat = 3, color: UIColor = .black, opacity: Float = 0.5) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    static func spaceView(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.constraintHeight(height)
        return view
    }
    
    static func underlineView(_ color: UIColor = .systemGray2) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        view.constraintHeight(1)
        return view
    }
}
