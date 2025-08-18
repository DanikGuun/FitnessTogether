
import UIKit

public struct ExerciseCellConfiguration: UIContentConfiguration {
    
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var isHighlited = false
    
    public func makeContentView() -> any UIView & UIContentView {
        ExerciseCellConentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> ExerciseCellConfiguration {
        if let state = state as? UICellConfigurationState {
            let isHighlited = state.isSelected || state.isHighlighted
            return ExerciseCellConfiguration(title: title, subtitle: subtitle, image: image, isHighlited: isHighlited)
        }
        return self
    }
    
    
}
