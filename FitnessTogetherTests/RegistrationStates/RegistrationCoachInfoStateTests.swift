import XCTest
import FTDomainData
@testable import FitnessTogether

final class RegistrationCoachInfoStateTests: XCTestCase {
    
    private var delegate: MockRegistrationDelegate!
    private var validator: MockValidator!
    private var state: RegistrationCoachInfoState!
    
    override func setUp() {
        super.setUp()
        delegate = MockRegistrationDelegate()
        validator = MockValidator()
        state = RegistrationCoachInfoState(validator: validator)
        state.delegate = delegate
    }
    
    override func tearDown() {
        delegate = nil
        validator = nil
        state = nil
        super.tearDown()
    }
    
    // MARK: - Applying Data
//    func test_Applying_SetsCoachData() {
//        var userRegister = FTUserRegister()
//        let jobTime = "5.5"
//        let organization = "Fitness Club"
//        let description = "Experienced coach"
//        
//        state.jobTimeTextField.text = jobTime
//        state.organizationTextField.text = organization
//        state.descriptionTextView.text = description
//        
//        state.apply(userRegister: &userRegister)
//        
//        XCTAssertEqual(userRegister.coachJobTime, Double(jobTime))
//        XCTAssertEqual(userRegister.coachOrganization, organization)
//        XCTAssertEqual(userRegister.description, description)
//    }
    
    // MARK: - Next Button
    func test_NextButton_StartInactive() {
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_ActiveWhenAllFieldsValid() {
        validator.isValidJobTime = true
        validator.isValidDescription = true
        
        state.jobTimeTextField.text = "5"
        state.organizationTextField.text = "Fitness Club"
        state.descriptionTextView.text = "About me"
        
        state.checkNextButtonAvailable(nil)
        
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
    func test_NextButton_DisabledWhenEmpty() {
        validator.isValidJobTime = false
        
        state.jobTimeTextField.text = "abc"
        state.organizationTextField.text = "Fitness Club"
        state.descriptionTextView.text = ""
        
        state.checkNextButtonAvailable(nil)
        
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InactiveAfterEmptingData() {
        state.jobTimeTextField.text = "test@example.com"
        state.organizationTextField.text = "password"
        state.descriptionTextView.text = "password"
        
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
        
        state.jobTimeTextField.text = ""
        state.checkNextButtonAvailable(nil)
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InvalidData_DoesNotTriggerNextStep() {
        validator.isValidDescription = false
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertFalse(wasCalled)
    }
    
    func test_NextButton_ValidData_TriggersNextStep() {
        validator.isValidJobTime = true
        validator.isValidDescription = true
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertTrue(wasCalled)
    }
    
    // MARK: - JobTime TextField Validation
    func test_JobTime_Valid_NoErrorDisplayed() {
        validator.isValidJobTime = true
        state.jobTimeTextField.text = "3.5"
        
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }
    
    func test_JobTime_Invalid_ErrorDisplayed() {
        validator.isValidJobTime = false
        validator.errorMessage = "Invalid experience"
        
        state.nextButtonPressed(nil)
        
        XCTAssertNotNil(delegate.lastViewInserted)
    }
    
    func test_JobTime_ValidAfterInvalid_RemovesError() {
        validator.isValidJobTime = false
        state.nextButtonPressed(nil)
        
        validator.isValidJobTime = true
        state.nextButtonPressed(nil)
        
        XCTAssertNotNil(delegate.lastViewRemoved)
    }
    
    func test_JobTime_DoubleInvalid_DoesNotDuplicateError() {
        validator.isValidJobTime = false
        
        state.nextButtonPressed(nil)
        let firstError = delegate.lastViewInserted
        
        delegate.lastViewInserted = nil
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }
    
    func test_JobTime_Invaild_EmptyMessage_DoesNotDisplayError() {
        validator.isValidJobTime = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }
    
    //MARK: - Description
    func test_Description_Valid_NoErrorDisplayed() {
        validator.isValidDescription = true
        state.descriptionTextView.text = "This is a valid description."
        
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }

    func test_Description_Invalid_ErrorDisplayed() {
        validator.isValidDescription = false
        validator.errorMessage = "Description is required"
        state.descriptionTextView.text = ""
        
        state.nextButtonPressed(nil)
        
        XCTAssertNotNil(delegate.lastViewInserted)
    }

    func test_Description_ValidAfterInvalid_RemovesError() {
        validator.isValidDescription = false
        state.descriptionTextView.text = ""
        state.nextButtonPressed(nil)
        
        validator.isValidDescription = true
        state.descriptionTextView.text = "Now it's valid"
        state.nextButtonPressed(nil)
        
        XCTAssertFalse(state.descriptionTextView.isError)
        XCTAssertNotNil(delegate.lastViewRemoved)
    }

    func test_Description_DoubleInvalid_DoesNotDuplicateError() {
        validator.isValidDescription = false
        state.descriptionTextView.text = ""
        
        state.nextButtonPressed(nil)
        let firstError = delegate.lastViewInserted
        
        delegate.lastViewInserted = nil
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }

    func test_Description_Invalid_EmptyMessage_DoesNotDisplayError() {
        validator.isValidDescription = false
        validator.errorMessage = nil
        state.descriptionTextView.text = ""
        
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }
    
}
