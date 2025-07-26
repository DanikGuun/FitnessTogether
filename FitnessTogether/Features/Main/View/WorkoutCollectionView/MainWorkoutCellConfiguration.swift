
import UIKit

public struct MainWorkoutCellConfiguration: UIContentConfiguration {
    
    var image: UIImage? = nil
    var title: String? = nil
    var subtitle: String? = nil
    
    public func makeContentView() -> any UIView & UIContentView {
        return MainWorkoutCollectionCellContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> MainWorkoutCellConfiguration {
        return self
    }
    
    
}
