
import CoreGraphics
import UIKit

public struct DC {
    
    public struct Layout {
        public static let leadingInset: CGFloat = 25
        public static let trailingInser: CGFloat = 25
        public static let spacing: CGFloat = 12
    }
    
    public struct Font {
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
