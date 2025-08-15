
import UIKit

public struct FTUserCellConfiguration: UIContentConfiguration {
    
    var image: UIImage? = nil
    var title: String? = nil
    var subtitle: String? = nil
    
    var attributedTitle: NSAttributedString? = nil
    var attributedSubtitle: NSAttributedString? = nil
    
    public func makeContentView() -> any UIView & UIContentView {
        return FTUserCollectionContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> FTUserCellConfiguration {
        return self
    }
    
    
}
