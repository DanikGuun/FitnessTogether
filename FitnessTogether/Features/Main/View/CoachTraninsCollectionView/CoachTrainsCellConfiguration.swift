
import UIKit

public struct CoachTrainsCellConfiguration: UIContentConfiguration {
    
    var image: UIImage? = nil
    var title: String? = nil
    var subtitle: String? = nil
    
    public func makeContentView() -> any UIView & UIContentView {
        return CoachTrainsCollectionCellContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> CoachTrainsCellConfiguration {
        return self
    }
    
    
}
