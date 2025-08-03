
import UIKit

public struct TimelineCellContentConfiguration: UIContentConfiguration {
    
    var items: [WorkoutTimelineItem] = []
    
    public func makeContentView() -> any UIView & UIContentView {
        return TimelineCellContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> TimelineCellContentConfiguration {
        return self
    }
    
    
}
