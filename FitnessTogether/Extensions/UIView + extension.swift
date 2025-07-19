
import UIKit

public extension UIView {
    func constrintHeight(_ height: CGFloat) {
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    static func spaceView(_ height: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.constrintHeight(height)
        return view
    }
}
