
import OutlineTextfield
import UIKit

public extension OutlinedTextfield {
    
    static func ftTextfield(placeholder: String = "") -> OutlinedTextfield {
        let standartAppearance = OutlineTextfieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            font: DC.Font.textfield,
            placeholderFont: DC.Font.textfield,
            outlineColor: .systemGray4,
            outlinedPlaceholderFont: DC.Font.textfield,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let activeAppearance = OutlineTextfieldAppearance(
            insets: UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10),
            font: DC.Font.textfield,
            placeholderFont: DC.Font.textfield,
            outlineColor: .ftOrange,
            outlinedPlaceholderFont: DC.Font.textfield,
            outlineCornerRadius: DC.Size.buttonCornerRadius-3
        )
        let textfield = OutlinedTextfield()
        textfield.standartAppearance = standartAppearance
        textfield.activeAppearance = activeAppearance
        return textfield
    }
    
}
