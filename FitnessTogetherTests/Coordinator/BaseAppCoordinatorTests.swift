
import XCTest
import FTDomainData
@testable import FitnessTogether

class BaseAppCoordinatorTests: XCTestCase {
    
    var window: UIWindow!
    fileprivate var ftManager: MockFTManager!
    fileprivate var authCoordinator: MockAuthCoordinator!
    fileprivate var coachCoordinator: MockCoachCoordinator!
    fileprivate var clientCoordinator: MockClientCoordinator!
    var coordinator: BaseAppCoordinator!
    
    override func setUp() {
        super.setUp()
        
        window = UIWindow()
        ftManager = MockFTManager()
        authCoordinator = MockAuthCoordinator()
        coachCoordinator = MockCoachCoordinator()
        clientCoordinator = MockClientCoordinator()
        
        let coordinatorBag = CoordinatorBag(
            authCoordinator: authCoordinator,
            coachCoordinator: coachCoordinator,
            clientCoordinator: clientCoordinator
        )
        
        
        coordinator = BaseAppCoordinator(window: window, coordinators: coordinatorBag, ftManager: ftManager)
    }
    
    override func tearDown() {
        authCoordinator = nil
        coachCoordinator = nil
        clientCoordinator = nil
        coordinator = nil
        window = nil
        ftManager = nil
        super.tearDown()
    }

    func test_HasNoPreviosLogin_AuthFlow() {
        ftManager._user.hasPreviousLogin = false
        coordinator.start()
        
        XCTAssertTrue(coordinator.currentCoordinator === authCoordinator)
    }
    
    func test_hasPreviousLogin_ClientRole_GotToClientFlow() {
        ftManager._user.hasPreviousLogin = true
        ftManager._user.user?.organization = nil //типа юзер, надо будет поправить
        coordinator.start()
        
        XCTAssertTrue(coordinator.currentCoordinator === clientCoordinator)
    }
    
    func test_hasPreviousLogin_CoachRole_GotToCoachFlow() {
        ftManager._user.hasPreviousLogin = true
        ftManager._user.user?.organization = "alsdkj"
        coordinator.start()
        
        XCTAssertTrue(coordinator.currentCoordinator === coachCoordinator)
    }
    
    func test_AuthCoordinator_DidFinish_StartClientFlow() {
        authCoordinator.delegate?.authCoordinatorDidFinishAuth(authCoordinator)
        
        XCTAssertTrue(coordinator.currentCoordinator === clientCoordinator)
    }
    
}

fileprivate class MockAuthCoordinator: AuthCoordinator {
    var delegate: (any FitnessTogether.AuthCoordinatorDelegate)?
    
    var currentVC: (UIViewController)?
    
    var mainVC: UIViewController = UIViewController()
    
    func show(_ viewController: UIViewController) {}
    
}

fileprivate class MockCoachCoordinator: CoachCoordinator {
    var delegate: (any FitnessTogether.CoachCoordinatorDelegate)?
    
    var currentVC: (UIViewController)?
    
    var mainVC: UIViewController = UIViewController()
    
    func show(_ viewController: UIViewController) {}
    
}

fileprivate class MockClientCoordinator: ClientCoordinator {
    var delegate: (any FitnessTogether.ClientCoordinatorDelegate)?
    
    var currentVC: (UIViewController)?
    
    var mainVC: UIViewController = UIViewController()
    
    func show(_ viewController: UIViewController) {}
    
}
