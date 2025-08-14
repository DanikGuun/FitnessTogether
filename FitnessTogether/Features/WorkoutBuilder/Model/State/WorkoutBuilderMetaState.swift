
import UIKit

public final class WorkoutBuilderMetaState: ScreenState {
    public var delegate: (any ScreenStateDelegate)?
    
    public func viewsToPresent() -> [UIView] {
        let lb = UILabel()
        lb.text = "WorkoutBuilderMetaState"
        lb.backgroundColor = .red
        return [lb]
    }
    
    
}
