

import XCTest
@testable import FitnessTogether
import FTDomainData

final class RegistrationModelTests: XCTestCase {
    
    fileprivate var userInterface: MockUserInterface!
    var model: RegistrationModel!
    
    override func setUp() {
        userInterface = MockUserInterface()
        model = BaseRegistrationModel(userInterface: userInterface, validator: MockValidator(), emailConfirmer: EmptyEmailConfirmer())
        super.setUp()
    }
    
    override func tearDown() {
        userInterface = nil
        model = nil
        super.tearDown()
    }
    
    func test_RegisterLoginCall() {
        model.register(user: model.userRegister, completion: { _ in })
        XCTAssertNotNil(userInterface.lastRegisterData)
        XCTAssertNotNil(userInterface.lastLoginData)
    }
    
}


fileprivate class EmptyEmailConfirmer: EmailConfirmer {
    func isEmailConsist(_ email: String, completion: ((ValidatorResult) -> ())?) {}
    func confirmEmail(_ email: String, completion: ((ValidatorResult) -> ())?) {}
}
