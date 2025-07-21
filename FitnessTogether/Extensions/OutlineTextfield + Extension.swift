
import OutlineTextfield
import UIKit

public extension OutlinedTextfield {
    
    static func ftTextfield(placeholder: String = "") -> OutlinedTextfield {
        let standartAppearance = OutlineTextfieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .label,
            placeholderColor: .systemGray4,
            lineWidth: 2,
            font: DC.Font.textfield,
            placeholderFont: DC.Font.textfield,
            outlineColor: .systemGray4,
            outlinedPlaceholderColor: .systemGray4,
            outlinedPlaceholderFont: DC.Font.textfield,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let activeAppearance = OutlineTextfieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .label,
            placeholderColor: .systemGray4,
            lineWidth: 2,
            font: DC.Font.textfield,
            placeholderFont: DC.Font.textfield,
            outlineColor: .ftOrange,
            outlinedPlaceholderColor: .ftOrange,
            outlinedPlaceholderFont: DC.Font.textfield,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let errorAppearance = OutlineTextfieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            textColor: .systemRed,
            placeholderColor: .systemRed,
            lineWidth: 2,
            font: DC.Font.textfield,
            placeholderFont: DC.Font.textfield,
            outlineColor: .systemRed,
            outlinedPlaceholderColor: .systemRed,
            outlinedPlaceholderFont: DC.Font.textfield,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let textfield = OutlinedTextfield()
        textfield.placeholderBehavior = .hide
        textfield.standartAppearance = standartAppearance
        textfield.activeAppearance = activeAppearance
        textfield.errorAppearance = errorAppearance
        return textfield
    }
    
}
