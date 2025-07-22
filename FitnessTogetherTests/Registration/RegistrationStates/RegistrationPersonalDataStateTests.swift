
import XCTest
import FTDomainData
@testable import FitnessTogether

final class RegistrationPersonalDataStateTests: XCTestCase {
    
    var delegate: MockRegistrationDelegate!
    var validator: MockValidator!
    var state: RegistrationPersonalDataState!
    
    override func setUp() {
        delegate = MockRegistrationDelegate()
        validator = MockValidator()
        state = RegistrationPersonalDataState(validator: validator)
        state.delegate = delegate
        super.setUp()
    }
    
    override func tearDown() {
        delegate = nil
        validator = nil
        state = nil
        super.tearDown()
    }
    
    func test_Applying() {
        var userRegister = FTUserRegister()
        let name = "TestName"
        let surname = "TestSurname"
        
        state.firstNameTextField.text = name
        state.lastNameTextField.text = surname
        state.apply(userRegister: &userRegister)
        
        XCTAssertEqual(userRegister.firstName, name)
        XCTAssertEqual(userRegister.lastName, surname)
    }
    
    //MARK: - Next Button
    func test_NextButton_StartInactive() {
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_ActiveAfterFullData() {
        XCTAssertFalse(state.nextButton.isEnabled)
        
        state.firstNameTextField.text = "Test"
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)
        
        state.lastNameTextField.text = "Test"
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)

        state.datePickerView.date = Date()
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InActiveAfterEmptingData() {
        state.firstNameTextField.text = "Test"
        state.lastNameTextField.text = "Test"
        state.datePickerView.date = Date()
        
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
        
        state.firstNameTextField.text = ""
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InvalidData_DoesNotTriggerNextStep() {
        validator.isValidFirstName = false
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertFalse(wasCalled)
    }
    
    func test_NextButton_ValidData_TriggersNextStep() {
        validator.isValidFirstName = true
        validator.isValidLastName = true
        validator.isValidDateOfBirth = true
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertTrue(wasCalled)
    }
    
    //MARK: - Firstname
    func test_FirstName_Valid_DelegateDoesNotRequestToAddIncorrectLabel() {
        validator.isValidFirstName = true
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    func test_FirstName_Inalid_DelegateRequestToAddIncorrectLabel() {
        validator.isValidFirstName = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
    }
    
    func test_FirstName_NotValid_After_Valid_DelegateRequestToAddAndRemoveIncorrectLabel() {
        validator.isValidFirstName = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        validator.isValidFirstName = true
        state.nextButtonPressed(nil)
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel)
    }
    
    func test_FirstName_DoubleNotValid_DelegateShouldntAddDoubleLabel() {
        validator.isValidFirstName = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        delegate.lastViewInserted = nil
        
        state.nextButtonPressed(nil)
        let secondIncorrectLabel = delegate.lastViewInserted
        XCTAssertNil(secondIncorrectLabel)
    }
    
    func test_FirstName_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidFirstName = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    //MARK: - Lastname
    func test_LastName_Valid_DelegateDoesNotRequestToAddIncorrectLabel() {
        validator.isValidLastName = true
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }

    func test_LastName_Invalid_DelegateRequestToAddIncorrectLabel() {
        validator.isValidLastName = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
    }

    func test_LastName_NotValid_After_Valid_DelegateRequestToAddAndRemoveIncorrectLabel() {
        validator.isValidLastName = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        validator.isValidLastName = true
        state.nextButtonPressed(nil)
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel)
    }

    func test_LastName_DoubleNotValid_DelegateShouldntAddDoubleLabel() {
        validator.isValidLastName = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        delegate.lastViewInserted = nil
        
        state.nextButtonPressed(nil)
        let secondIncorrectLabel = delegate.lastViewInserted
        XCTAssertNil(secondIncorrectLabel)
    }
    
    func test_LastName_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidLastName = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
    //MARK: - Datepicker
    func test_DatePicker_Valid_DelegateDoesNotRequestToAddIncorrectLabel() {
        validator.isValidDateOfBirth = true
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }

    func test_DatePicker_Invalid_DelegateRequestToAddIncorrectLabel() {
        validator.isValidDateOfBirth = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
    }

    func test_DatePicker_NotValid_After_Valid_DelegateRequestToAddAndRemoveIncorrectLabel() {
        validator.isValidDateOfBirth = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        validator.isValidDateOfBirth = true
        state.nextButtonPressed(nil)
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel)
    }

    func test_DatePicker_DoubleNotValid_DelegateShouldntAddDoubleLabel() {
        validator.isValidDateOfBirth = false
        state.nextButtonPressed(nil)
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel)
        
        delegate.lastViewInserted = nil
        
        state.nextButtonPressed(nil)
        let secondIncorrectLabel = delegate.lastViewInserted
        XCTAssertNil(secondIncorrectLabel)
    }
    
    func test_DatePicker_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidDateOfBirth = false  // Предполагая, что у вас есть такое свойство
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel)
    }
    
}
