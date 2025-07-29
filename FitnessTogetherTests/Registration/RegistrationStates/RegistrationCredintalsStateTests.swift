
import XCTest
import FTDomainData
@testable import FitnessTogether

final class RegistrationCredintalsStateTests: XCTestCase {
    
    var delegate: MockScreenStateDelegate!
    var validator: MockValidator!
    fileprivate var emailConfirmer: MockEmailConfirmer!
    var state: RegistrationCredintalsState!
    
    override func setUp() {
        delegate = MockScreenStateDelegate()
        validator = MockValidator()
        emailConfirmer = MockEmailConfirmer()
        emailConfirmer.isEmailExists = false
        state = RegistrationCredintalsState(validator: validator, emailConfirmer: emailConfirmer)
        state.delegate = delegate
        super.setUp()
    }
    
    override func tearDown() {
        delegate = nil
        validator = nil
        emailConfirmer = nil
        state = nil
        super.tearDown()
    }
    
    func test_Applying() {
        var userRegister = FTUserRegister()
        let email = "test@example.com"
        let password = "password"
        
        state.emailTextField.text = email
        state.passwordTextField.text = password
        state.apply(userRegister: &userRegister)
        
        XCTAssertEqual(userRegister.email, email)
        XCTAssertEqual(userRegister.password, password)
    }
    
    //MARK: - Next Button
    func test_NextButton_StartInactive() {
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_ActiveAfterFullData() {
        XCTAssertFalse(state.nextButton.isEnabled)
        
        state.emailTextField.text = "test@example.com"
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)
        
        state.passwordTextField.text = "password"
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)

        state.confirmPasswordTextField.text = "password"
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InactiveAfterEmptingData() {
        state.emailTextField.text = "test@example.com"
        state.passwordTextField.text = "password"
        state.confirmPasswordTextField.text = "password"
        
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
        
        state.emailTextField.text = ""
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InvalidData_DoesNotTriggerNextStep() {
        validator.isValidEmail = false
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertFalse(wasCalled)
    }
    
    func test_NextButton_ValidData_TriggersNextStep() {
        validator.isValidEmail = true
        emailConfirmer.isEmailExists = false
        validator.isValidPassword = true
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertTrue(wasCalled)
    }
    
    func test_email_AlreadyExists_NotTriggerNext() {
        emailConfirmer.isEmailExists = true
        
        state.nextButtonPressed(nil)
        
        XCTAssertFalse(delegate.goNextCalled)
    }
    
    //MARK: - Email
    func test_Email_Valid_DelegateDoesNotRequestToAddIncorrectLabel() {
        validator.isValidEmail = true
        emailConfirmer.isEmailExists = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    func test_Email_Invalid_DelegateRequestToAddIncorrectLabel() {
        validator.isValidEmail = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
    }
    
    func test_Email_NotValid_After_Valid_DelegateRequestToAddAndRemoveIncorrectLabel() {
        validator.isValidEmail = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        validator.isValidEmail = true
        state.nextButtonPressed(nil)
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel)
    }
    
    func test_Email_DoubleNotValid_DelegateShouldntAddDoubleLabel() {
        validator.isValidEmail = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        delegate.lastViewInserted = nil
        
        state.nextButtonPressed(nil)
        let secondIncorrectLabel = delegate.lastViewInserted
        XCTAssertNil(secondIncorrectLabel)
    }
    
    func test_Email_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidEmail = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    //MARK: - Password
    func test_Password_Valid_DelegateDoesNotRequestToAddIncorrectLabel() {
        validator.isValidPassword = true
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    func test_Password_Invalid_DelegateRequestToAddIncorrectLabel() {
        validator.isValidPassword = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
    }
    
    func test_Password_NotValid_After_Valid_DelegateRequestToAddAndRemoveIncorrectLabel() {
        validator.isValidPassword = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        validator.isValidPassword = true
        state.nextButtonPressed(nil)
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel)
    }
    
    func test_Password_DoubleNotValid_DelegateShouldntAddDoubleLabel() {
        validator.isValidPassword = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        delegate.lastViewInserted = nil
        
        state.nextButtonPressed(nil)
        let secondIncorrectLabel = delegate.lastViewInserted
        XCTAssertNil(secondIncorrectLabel)
    }
    
    func test_Password_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidPassword = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    //MARK: - Confirm Password
    func test_ConfirmPassword_Valid_DelegateDoesNotRequestToAddIncorrectLabel() {
        validator.isValidPassword = true
        validator.isValidConfirmPassword = true
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    func test_ConfirmPassword_Invalid_DelegateRequestToAddIncorrectLabel() {
        validator.isValidPassword = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
    }
    
    func test_ConfirmPassword_NotValid_After_Valid_DelegateRequestToAddAndRemoveIncorrectLabel() {
        validator.isValidPassword = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        validator.isValidPassword = true
        state.nextButtonPressed(nil)
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel)
    }
    
    func test_ConfirmPassword_DoubleNotValid_DelegateShouldntAddDoubleLabel() {
        validator.isValidPassword = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        delegate.lastViewInserted = nil
        
        state.nextButtonPressed(nil)
        let secondIncorrectLabel = delegate.lastViewInserted
        XCTAssertNil(secondIncorrectLabel)
    }
    
    func test_ConfirmPassword_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidPassword = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
}
