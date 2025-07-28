

import XCTest
import FTDomainData
@testable import FitnessTogether

final class RegistrationRoleStateTests: XCTestCase {
    
    var delegate: MockScreenStateDelegate!
    var state: RegistrationRoleState!
    
    override func setUp() {
        super.setUp()
        delegate = MockScreenStateDelegate()
        state = RegistrationRoleState()
        state.delegate = delegate
    }
    
    override func tearDown() {
        delegate = nil
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
    
    func test_NextButton_NoRole_DoesNotTriggerNextStep() {
        state.nextButtonPressed(nil)
        XCTAssertFalse(delegate.goNextCalled)
    }
    
    func test_RoleSelected_NextButtonActive() {
        state.clientButton.isSelected = true
        state.nextButtonPressed(nil)
        XCTAssertTrue(delegate.goNextCalled)
    }
    
    func test_NextButton_RoleSelected_TriggersNextStep() {
        state.coachButton.isSelected = true
        state.nextButtonPressed(nil)
        XCTAssertTrue(delegate.goNextCalled)
    }
    
}

