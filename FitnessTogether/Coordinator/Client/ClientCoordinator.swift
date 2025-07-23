
public protocol ClientCoordinator: Coordinator {
    var delegate: (any ClientCoordinatorDelegate)? { get set }
}

public protocol ClientCoordinatorDelegate {
    
}

extension ClientCoordinatorDelegate {
    
}
