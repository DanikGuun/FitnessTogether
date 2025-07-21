

import XCTest
import FTDomainData
@testable import FitnessTogether

final class RegistrationRoleStateTests: XCTestCase {
    
    var state: RegistrationRoleState!
    
    override func setUp() {
        super.setUp()
        state = RegistrationRoleState(validator: MockValidator())
    }
    
    override func tearDown() {
        state = nil
        super.tearDown()
    }
    
    func test_Applying() {
        var userRegister = FTUserRegister()
        state.coachButton.isSelected = true
        
        state.apply(userRegister: &userRegister)
        
        XCTAssertEqual(userRegister.role, .coach)
    }
    
    func test_NoRoleSelected_NextButtonInactive() {
        state.coachButton.isSelected = false
        state.clientButton.isSelected = false
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_RoleSelected_NextButtonActive() {
        state.clientButton.isSelected = true
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
}

