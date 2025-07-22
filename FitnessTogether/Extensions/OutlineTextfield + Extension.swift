
import UIKit
import OutlineTextField

public extension OutlinedTextField {
    
    static func ftTextField(placeholder: String = "") -> OutlinedTextField {
        let standartAppearance = OutlineTextFieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .label,
            placeholderColor: .systemGray4,
            lineWidth: 2,
            font: DC.Font.textField,
            placeholderFont: DC.Font.textField,
            outlineColor: .systemGray4,
            outlinedPlaceholderColor: .systemGray4,
            outlinedPlaceholderFont: DC.Font.textField,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let activeAppearance = OutlineTextFieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .label,
            placeholderColor: .systemGray4,
            lineWidth: 2,
            font: DC.Font.textField,
            placeholderFont: DC.Font.textField,
            outlineColor: .ftOrange,
            outlinedPlaceholderColor: .ftOrange,
            outlinedPlaceholderFont: DC.Font.textField,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let errorAppearance = OutlineTextFieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .systemRed,
            placeholderColor: .systemRed,
            lineWidth: 2,
            font: DC.Font.textField,
            placeholderFont: DC.Font.textField,
            outlineColor: .systemRed,
            outlinedPlaceholderColor: .systemRed,
            outlinedPlaceholderFont: DC.Font.textField,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let textField = OutlinedTextField()
        textField.placeholder = placeholder
        textField.constraintHeight(DC.Size.buttonHeight)
        textField.placeholderBehavior = .hide
        textField.standartAppearance = standartAppearance
        textField.activeAppearance = activeAppearance
        textField.errorAppearance = errorAppearance
        return textField
    }
    
}
