
import UIKit

public extension UILabel {
    
    static func incorrectData(_ title: String?) -> UILabel {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = DC.Font.roboto(weight: .regular, size: 14)
        label.textAlignment = .center
        label.text = title
        return label
    }
    
}
