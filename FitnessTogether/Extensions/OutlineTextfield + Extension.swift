
import UIKit
import OutlineTextField

public extension OutlinedTextField {
    
    static func ftTextField(placeholder: String = "") -> OutlinedTextField {
        let standartAppearance = OutlineTextFieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .label,
            placeholderColor: .systemGray4,
            lineWidth: 2,
            font: DC.Font.TextField,
            placeholderFont: DC.Font.TextField,
            outlineColor: .systemGray4,
            outlinedPlaceholderColor: .systemGray4,
            outlinedPlaceholderFont: DC.Font.TextField,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let activeAppearance = OutlineTextFieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .label,
            placeholderColor: .systemGray4,
            lineWidth: 2,
            font: DC.Font.TextField,
            placeholderFont: DC.Font.TextField,
            outlineColor: .ftOrange,
            outlinedPlaceholderColor: .ftOrange,
            outlinedPlaceholderFont: DC.Font.TextField,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let errorAppearance = OutlineTextFieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .systemRed,
            placeholderColor: .systemRed,
            lineWidth: 2,
            font: DC.Font.TextField,
            placeholderFont: DC.Font.TextField,
            outlineColor: .systemRed,
            outlinedPlaceholderColor: .systemRed,
            outlinedPlaceholderFont: DC.Font.TextField,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let TextField = OutlinedTextField()
        TextField.placeholderBehavior = .hide
        TextField.standartAppearance = standartAppearance
        TextField.activeAppearance = activeAppearance
        TextField.errorAppearance = errorAppearance
        return TextField
    }
    
}
