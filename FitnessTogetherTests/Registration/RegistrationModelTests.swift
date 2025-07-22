

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
    
    func test_RegisterLoginCall_AfterStates() {
        let register = FTUserRegister(email: "emzil", password: "pasword")
        model.userRegister = register
        for _ in 0...model.stepCount { let _ = model.goNext() }
        
        XCTAssertEqual(userInterface.lastRegisterData, register)
        XCTAssertEqual(userInterface.lastLoginData?.email, register.email)
        XCTAssertEqual(userInterface.lastLoginData?.password, register.password)
    }
    
}

fileprivate class MockUserInterface: FTUserInterface {
    var token: String? = nil
    var hasPreviousLogin: Bool = false
    
    var lastRegisterData: FTDomainData.FTUserRegister?
    var lastLoginData: FTDomainData.FTUserLogin?
    
    func register(data: FTDomainData.FTUserRegister, completion: FTDomainData.FTCompletion<Data>) {
        lastRegisterData = data
        completion?(.success(Data()))
    }
    
    func login(data: FTDomainData.FTUserLogin, completion: FTDomainData.FTCompletion<Data>) {
        lastLoginData = data
        completion?(.success(Data()))
    }
    
    func loginWithPreviousCredentials(completion: FTDomainData.FTCompletion<Data>) {
        
    }
    
    func logout(completion: FTDomainData.FTCompletion<Void>) {
        
    }
    
    func current(completion: FTDomainData.FTCompletion<FTDomainData.FTUser>) {
        
    }
    
    func addClientToCoach(clientId: String, completion: FTDomainData.FTCompletion<Void>) {
        
    }
    
    func getClients(completion: FTDomainData.FTCompletion<[FTDomainData.FTUser]>) {
        
    }
    
    
}

fileprivate class EmptyEmailConfirmer: EmailConfirmer {
    func confirmEmail(_ email: String, completion: ((ValidatorResult) -> ())?) {
        
    }
}
