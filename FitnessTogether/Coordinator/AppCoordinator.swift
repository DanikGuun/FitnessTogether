
import UIKit

public protocol AppCoordinator {
    var currentCoordinator: any Coordinator { get }
}

public final class BaseAppCoordinator: NSObject {
    
    var authCoordinator: AuthCoordinator
    var coachCoordinator: CoachCoordinator
    var clientCoordinator: ClientCoordinator
    var ftManager: FTManager
    var window: UIWindow
    
    var currentCoordinator: (any Coordinator)?
    
    init(window: UIWindow, coordinators: CoordinatorBag, ftManager: FTManager) {
        self.authCoordinator = coordinators.authCoordinator
        self.coachCoordinator = coordinators.coachCoordinator
        self.clientCoordinator = coordinators.clientCoordinator
        self.ftManager = ftManager
        self.window = window
        super.init()
        authCoordinator.delegate = self
        coachCoordinator.delegate = self
        clientCoordinator.delegate = self
        start()
        window.makeKeyAndVisible()
    }
    
    public func start() {
        if ftManager.user.hasPreviousLogin == false {
            setCoordinator(authCoordinator)
        }
        else {
            setUserFlowCoordinator()
        }
    }
    
    private func setUserFlowCoordinator() {
        ftManager.user.loginWithPreviousCredentials(completion: { [weak self] _ in
            guard let self else { return }
            ftManager.user.current(completion: { [weak self] result in
                guard let self else { return }
                
                switch result {
                case .success(let user):
                    if user.role == .coach {
                        setCoordinator(coachCoordinator)
                    }
                    else {
                        setCoordinator(clientCoordinator)
                    }
                case .failure(let error): print(error.localizedDescription)
                    
                }
                
            })
        })
    }
    
    private func setCoordinator(_ coordinator: any Coordinator) {
        currentCoordinator = coordinator
        window.rootViewController = coordinator.mainVC
    }
    
}

extension BaseAppCoordinator: AuthCoordinatorDelegate {
    
    public func authCoordinatorDidFinishAuth(_ authCoordinator: any AuthCoordinator) {
        setUserFlowCoordinator()
    }
    
}

extension BaseAppCoordinator: CoachCoordinatorDelegate {
    public func coachCoordinatorShouldGoToLogin(_ coachCoordinator: any CoachCoordinator) {
        setCoordinator(authCoordinator)
    }
}

extension BaseAppCoordinator: ClientCoordinatorDelegate {
    public func clientCoordinatorShouldGoToLogin(_ clientCoordinator: any ClientCoordinator) {
        setCoordinator(authCoordinator)
    }
}

public struct CoordinatorBag {
    var authCoordinator: AuthCoordinator
    var coachCoordinator: CoachCoordinator
    var clientCoordinator: ClientCoordinator
}
