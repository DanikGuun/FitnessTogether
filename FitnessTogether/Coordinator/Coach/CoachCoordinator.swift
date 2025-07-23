
import UIKit

public protocol CoachCoordinator: Coordinator {
    var delegate: (any CoachCoordinatorDelegate)? { get set }
}

public protocol CoachCoordinatorDelegate {
    
}

public extension CoachCoordinatorDelegate {
    
}
