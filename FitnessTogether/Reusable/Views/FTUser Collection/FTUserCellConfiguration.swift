
import UIKit

public struct FTUserCellConfiguration: UIContentConfiguration {
    
    var image: UIImage? = nil
    var title: String? = nil
    var subtitle: String? = nil
    var isSelected = false
    var lineWidth: CGFloat = 1
    
    var attributedTitle: NSAttributedString? = nil
    var attributedSubtitle: NSAttributedString? = nil
    
    public func makeContentView() -> any UIView & UIContentView {
        return FTUserCollectionContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> FTUserCellConfiguration {
        if let state = state as? UICellConfigurationState {
            let isSelected = state.isSelected || state.isHighlighted
            return FTUserCellConfiguration(image: image, title: title, subtitle: subtitle,
                                           isSelected: isSelected, lineWidth: lineWidth,
                                           attributedTitle: attributedTitle, attributedSubtitle: attributedSubtitle)
        }
        return self
    }
    
    
}
