
import UIKit

public extension UIButton {
    
    static func ftFilled(title: String = "") -> UIButton {
        let button = UIButton(configuration: .filled())
        button.constraintHeight(DC.Size.buttonHeight)
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
        button.constraintHeight(DC.Size.buttonHeight)
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
    
    static func secondaryButton(title: String) -> UIButton {
        let attrs = AttributeContainer([
            .font : DC.Font.additionalInfo,
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemGray
        ])
        let title = AttributedString(title, attributes: attrs)
        
        let button = UIButton(configuration: .plain())
        button.configuration?.attributedTitle = title
        button.constraintHeight(20)
        
        return button
    }
    
}
