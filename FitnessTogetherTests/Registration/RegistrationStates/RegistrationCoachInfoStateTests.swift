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
    func test_Applying_SetsCoachData() {
        var userRegister = FTUserRegister()
        let jobTime = "5,5"
        let organization = "Fitness Club"
        let description = "Experienced coach"
        
        state.workExperienceTextField.text = jobTime
        state.organizationTextField.text = organization
        state.descriptionTextView.text = description
        
        state.apply(userRegister: &userRegister)
        
        XCTAssertEqual(userRegister.workExperience, jobTime.doubleValue)
        XCTAssertEqual(userRegister.organization, organization)
        XCTAssertEqual(userRegister.description, description)
    }
    
    // MARK: - Next Button
    func test_NextButton_StartInactive() {
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_ActiveWhenAllFieldsValid() {
        validator.isValidWorkExperience = true
        validator.isValidDescription = true
        
        state.workExperienceTextField.text = "5,5"
        state.organizationTextField.text = "Fitness Club"
        state.descriptionTextView.text = "About me"
        
        state.checkNextButtonAvailable(nil)
        
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
    func test_NextButton_DisabledWhenEmpty() {
        state.workExperienceTextField.text = ""
        state.organizationTextField.text = "Fitness"
        state.descriptionTextView.text = ""
        
        state.checkNextButtonAvailable(nil)
        
        XCTAssertFalse(state.nextButton.isEnabled)
    }
    
    func test_NextButton_Enabled_WithoutDescritpion() {
        state.workExperienceTextField.text = "alsdjf"
        state.organizationTextField.text = "alsdjf"
        state.descriptionTextView.text = ""
        
        state.checkNextButtonAvailable(nil)
        
        XCTAssertTrue(state.nextButton.isEnabled)
    }
    
    func test_NextButton_InactiveAfterEmptingData() {
        state.workExperienceTextField.text = "test@example.com"
        state.organizationTextField.text = "password"
        state.descriptionTextView.text = "password"
        
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled)
        
        state.workExperienceTextField.text = ""
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
        validator.isValidWorkExperience = true
        validator.isValidDescription = true
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertTrue(wasCalled)
    }
    
    // MARK: - WorkExperience TextField Validation
    func test_WorkExperience_Valid_NoErrorDisplayed() {
        validator.isValidWorkExperience = true
        state.workExperienceTextField.text = "3,5"
        
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }
    
    func test_WorkExperience_Invalid_ErrorDisplayed() {
        validator.isValidWorkExperience = false
        validator.errorMessage = "Invalid experience"
        
        state.nextButtonPressed(nil)
        
        XCTAssertNotNil(delegate.lastViewInserted)
    }
    
    func test_WorkExperience_ValidAfterInvalid_RemovesError() {
        validator.isValidWorkExperience = false
        state.nextButtonPressed(nil)
        
        validator.isValidWorkExperience = true
        state.nextButtonPressed(nil)
        
        XCTAssertNotNil(delegate.lastViewRemoved)
    }
    
    func test_WorkExperience_DoubleInvalid_DoesNotDuplicateError() {
        validator.isValidWorkExperience = false
        
        state.nextButtonPressed(nil)
        let firstError = delegate.lastViewInserted
        
        delegate.lastViewInserted = nil
        state.nextButtonPressed(nil)
        
        XCTAssertNil(delegate.lastViewInserted)
    }
    
    func test_WorkExperience_Invaild_EmptyMessage_DoesNotDisplayError() {
        validator.isValidWorkExperience = false
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
