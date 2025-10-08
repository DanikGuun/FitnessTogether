
import UIKit

public protocol CoachCoordinator: Coordinator {
    var delegate: (any CoachCoordinatorDelegate)? { get set }
}

public protocol CoachCoordinatorDelegate {
    func coachCoordinatorShouldGoToLogin(_ coachCoordinator: CoachCoordinator)
}

public extension CoachCoordinatorDelegate {
    func coachCoordinatorShouldGoToLogin(_ coachCoordinator: CoachCoordinator) {}
}
