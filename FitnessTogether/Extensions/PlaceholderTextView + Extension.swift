
import OutlineTextField
import UIKit

public extension PlaceholderTextView {
    
    static func ftTextView(placeholder: String) -> PlaceholderTextView {
        let standart = PlaceholderTextViewAppearance(
            textFont: DC.Font.textField,
            textColor: .systemGray4,
            placeholderFont: DC.Font.textField,
            placeholderColor: .systemGray4,
            cornerRadius: DC.Size.buttonCornerRadius,
            lineWidth: 2,
            lineColor: .systemGray4,
            insets: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        )
        let active = PlaceholderTextViewAppearance(
            textFont: DC.Font.textField,
            textColor: .label,
            placeholderFont: DC.Font.textField,
            placeholderColor: .systemGray4,
            cornerRadius: DC.Size.buttonCornerRadius,
            lineWidth: 2,
            lineColor: .ftOrange,
            insets: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        )
        let error = PlaceholderTextViewAppearance(
            textFont: DC.Font.textField,
            textColor: .systemRed,
            placeholderFont: DC.Font.textField,
            placeholderColor: .systemRed,
            cornerRadius: DC.Size.buttonCornerRadius,
            lineWidth: 2,
            lineColor: .systemRed,
            insets: UIEdgeInsets(top: 18, left: 20, bottom: 18, right: 20)
        )
        let textView = PlaceholderTextView()
        textView.standartAppearance = standart
        textView.activeAppearance = active
        textView.errorAppearance = error
        textView.placeholder = placeholder
        return textView
    }
    
}
