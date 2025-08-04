
import UIKit

public struct TimelineCellContentConfiguration: UIContentConfiguration {
    
    var items: [WorkoutTimelineItem] = []
    //для сихронизации высоты кланедарей
    var timelineDelegate: TimelineDelegate?
    var shouldSyncHeights: Bool = true
    static var timelineHeight: CGFloat = 600
    static var timelineContentOffset: CGPoint = .zero
    
    public func makeContentView() -> any UIView & UIContentView {
        return TimelineCellContentView(configuration: self)
    }
    
    public func updated(for state: any UIConfigurationState) -> TimelineCellContentConfiguration {
        return self
    }
    
    
}
