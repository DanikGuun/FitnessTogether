
public protocol ClientCoordinator: Coordinator {
    var delegate: (any ClientCoordinatorDelegate)? { get set }
}

public protocol ClientCoordinatorDelegate {
    func clientCoordinatorShouldGoToLogin(_ clientCoordinator: ClientCoordinator)
}

public extension ClientCoordinatorDelegate {
    func clientCoordinatorShouldGoToLogin(_ clientCoordinator: ClientCoordinator) {}
}
