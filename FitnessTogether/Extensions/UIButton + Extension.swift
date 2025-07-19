
import UIKit

public extension UIButton {
    
    static func ftFilled(title: String = "") -> UIButton {
        let button = UIButton(configuration: .filled())
        let attributes = AttributeContainer([
            .font: DC.Font.roboto(weight: .semibold, size: 16)
        ])
        
        var conf = button.configuration
        conf?.baseBackgroundColor = .ftOrange
        conf?.background.cornerRadius = DC.Size.buttonCornerRadius
        conf?.attributedTitle = AttributedString(title, attributes: attributes)
        button.configuration = conf
        
        return button
    }
    
    static func ftPlain(title: String = "") -> UIButton {
        let button = UIButton(configuration: .plain())
        let attributes = AttributeContainer([
            .font: DC.Font.roboto(weight: .semibold, size: 16)
        ])
        
        var conf = button.configuration
        conf?.background.cornerRadius = DC.Size.buttonCornerRadius
        conf?.attributedTitle = AttributedString(title, attributes: attributes)
        conf?.baseForegroundColor = .ftOrange
        conf?.background.strokeColor = .ftOrange
        conf?.background.strokeWidth = 2
        button.configuration = conf
        
        return button
    }
    
    
}
