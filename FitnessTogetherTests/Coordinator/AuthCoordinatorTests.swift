

import XCTest
@testable import FitnessTogether

final class AuthCoordinatorTests: XCTestCase {
    
    fileprivate var delegate: MockAuthCoordinatorDelegate!
    fileprivate var factory: MockAuthVCFactory!
    var coordinator: BaseAuthCoordinator!
    
    override func setUp() {
        delegate = MockAuthCoordinatorDelegate()
        factory = MockAuthVCFactory()
        coordinator = BaseAuthCoordinator(factory: factory)
        coordinator.delegate = delegate
        coordinator.needAnimate = false
        super.setUp()
    }
    
    override func tearDown() {
        delegate = nil
        factory = nil
        coordinator = nil
        super.tearDown()
    }
    
    func test_Auth_MainScreen() {
        XCTAssertEqual(factory.lastVCMaked, .auth)
        let title = coordinator.currentVC?.title
        XCTAssertEqual(title, "Auth")
    }
    
    func test_GoTo_Login() {
        factory.authDelegate?.authViewControllerGoToLogin(UIViewController())
        XCTAssertEqual(factory.lastVCMaked, .login)
        let title = coordinator.currentVC?.title
        XCTAssertEqual(title, "Login")
    }
    
    func test_GoTo_Registration() {
        factory.authDelegate?.authViewControllerGoToRegister(UIViewController())
        XCTAssertEqual(factory.lastVCMaked, .registration)
        let title = coordinator.currentVC?.title
        XCTAssertEqual(title, "Registration")
    }
    
    func test_GoTo_PasswordRecover() {
        coordinator.loginViewControllerGoToRecoverPassword(UIViewController())
        XCTAssertEqual(factory.lastVCMaked, .passwordRecover)
        let title = coordinator.currentVC?.title
        XCTAssertEqual(title, "Password recover")
    }
    
    func test_show() {
        let vc = UIViewController()
        vc.title = "controller"
        coordinator.show(vc)
        XCTAssertEqual(coordinator.currentVC?.title, vc.title)
    }
    
    func test_LoginFinish_DidFinish() {
        coordinator.loginViewControllerDidLogin(UIViewController())
        XCTAssertTrue(delegate.didfinish)
    }
    
    func test_RegistrationFinish_DidFinish() {
        coordinator.registrationViewControllerDidFinish(UIViewController())
        XCTAssertTrue(delegate.didfinish)
    }
    
    func test_RecoverPassword_DidDinish_PopRecoverVC() {
        coordinator.authViewControllerGoToLogin(UIViewController())
        coordinator.loginViewControllerGoToRecoverPassword(UIViewController())
        XCTAssertEqual(coordinator.currentVC?.title, "Password recover")
        
        coordinator.passwordRecoverDidFinish(UIViewController())
        XCTAssertEqual(coordinator.currentVC?.title, "Login")
    }
    
}

fileprivate class MockAuthVCFactory: AuthViewControllerFactory {
    
    var authDelegate: AuthViewControllerDelegate?
    var registrationDelegate: RegistrationViewControllerDelegate?
    var loginDelegate: LoginViewControllerDelegate?
    var passwordRecoverDelegate: PasswordRecoverControllerDelegate?

    var lastVCMaked: VCMaked?
        
    func makeAuthVC(delegate: (any AuthViewControllerDelegate)?) -> UIViewController {
        authDelegate = delegate
        lastVCMaked = .auth
        let vc = UIViewController()
        vc.title = "Auth"
        return vc
    }
    
    func makeRegistrationVC(delegate: (any RegistrationViewControllerDelegate)?) -> UIViewController {
        registrationDelegate = delegate
        lastVCMaked = .registration
        let vc = UIViewController()
        vc.title = "Registration"
        return vc
    }
    
    func makeLoginVC(delegate: (any LoginViewControllerDelegate)?) -> UIViewController {
        loginDelegate = delegate
        lastVCMaked = .login
        let vc = UIViewController()
        vc.title = "Login"
        return vc
    }
    
    func makePasswordRecoveryVC(delegate: (any PasswordRecoverControllerDelegate)?) -> UIViewController {
        passwordRecoverDelegate = delegate
        lastVCMaked = .passwordRecover
        let vc = UIViewController()
        vc.title = "Password recover"
        return vc
    }

    fileprivate enum VCMaked {
        case auth
        case registration
        case login
        case passwordRecover
    }
    
}

fileprivate class MockAuthCoordinatorDelegate: AuthCoordinatorDelegate {
    var didfinish = false
    
    func authCoordinatorDidFinishAuth(_ authCoordinator: any AuthCoordinator) {
        didfinish = true
    }
}
