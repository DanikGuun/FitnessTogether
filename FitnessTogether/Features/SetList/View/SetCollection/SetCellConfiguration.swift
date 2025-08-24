
import UIKit

public struct SetCellConfiguration: UIContentConfiguration {
    
    var number: Int = 0
    var count: Int = 0
    var weight: Int = 0
    var isHighlited: Bool = false
    
    public func makeContentView() -> any UIView & UIContentView {
        SetCellContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> SetCellConfiguration {
        if let state = state as? UICellConfigurationState {
            let isHighlighted = state.isHighlighted || state.isSelected
            return SetCellConfiguration(number: number, count: count, weight: weight, isHighlited: isHighlighted)
        }
        return self
    }
    
    
}
