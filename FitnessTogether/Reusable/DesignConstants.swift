
import CoreGraphics
import UIKit

public struct DC {
    
    public struct Layout {
        public static let leadingInset: CGFloat = 25
        public static let trailingInset: CGFloat = 25
        public static let spacing: CGFloat = 12
        public static let insets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        public static let calendarLeftInset: CGFloat = 50
    }
    
    public struct Size {
        public static let buttonHeight: CGFloat = 54
        public static let smallButtonHeight: CGFloat = 34
        public static let buttonCornerRadius: CGFloat = 20
    }
    
    public struct Font {
        public static let cellTitle = DC.Font.roboto(weight: .medium, size: 16)
        public static let cellSubtitle = DC.Font.roboto(weight: .semibold, size: 12)
        public static let headline = DC.Font.roboto(weight: .medium, size: 20)
        public static let textField = DC.Font.roboto(weight: .medium, size: 15)
        public static let additionalInfo = DC.Font.roboto(weight: .regular, size: 12)
        
        public static func roboto(weight: UIFont.Weight = .regular, size: CGFloat = 16) -> UIFont {
            let descriptor = UIFontDescriptor(fontAttributes: [
                .family: "Roboto",
                .traits: [UIFontDescriptor.TraitKey.weight: weight],
                .size: size
            ])
            let font = UIFont(descriptor: descriptor, size: size)
            return font
        }
    }
    
}
