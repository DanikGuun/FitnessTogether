
import UIKit

public protocol AuthCoordinator: Coordinator {
    var delegate: (any AuthCoordinatorDelegate)? { get set }
}

public protocol AuthCoordinatorDelegate {
    func authCoordinatorDidFinishAuth(_ authCoordinator: any AuthCoordinator)
}

public extension AuthCoordinatorDelegate {
    func authCoordinatorDidFinishAuth(_ authCoordinator: any AuthCoordinator) {}
}
