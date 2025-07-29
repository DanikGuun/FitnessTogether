import XCTest
import FTDomainData
@testable import FitnessTogether

final class PasswordRecoverEmailStateTests: XCTestCase {
    var delegate: MockScreenStateDelegate!
    var validator: MockValidator!
    fileprivate var emailConfirmer: MockEmailConfirmer!
    var state: PasswordRecoverEmailState!

    override func setUp() {
        super.setUp()
        delegate = MockScreenStateDelegate()
        validator = MockValidator()
        emailConfirmer = MockEmailConfirmer()
        state = PasswordRecoverEmailState(validator: validator, emailConfirmer: emailConfirmer)
        state.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
        validator = nil
        emailConfirmer = nil
        state = nil
        super.tearDown()
    }

    // MARK: - Next Button

    func test_NextButton_StartInactive() {
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть неактивна при старте, если поля пусты.")
    }

    func test_NextButton_ActiveAfterFullData() {
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть неактивна изначально.")
        
        state.emailTextField.text = "test@example.com"
        state.checkNextButtonAvailable(nil)
        
        XCTAssertTrue(state.nextButton.isEnabled, "Кнопка 'Далее' должна стать активной после заполнения email.")
    }

    func test_NextButton_InactiveAfterEmptyingData() {
        state.emailTextField.text = "test@example.com"
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть активна после заполнения.")

        state.emailTextField.text = ""
        state.checkNextButtonAvailable(nil)
        
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна стать неактивной после очистки поля.")
    }

    func test_NextButton_InvalidData_DoesNotTriggerNextStep() {
        validator.isValidEmail = false
        state.emailTextField.text = "invalid-email"
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertFalse(wasCalled, "Делегат не должен быть вызван, если данные невалидны.")
    }

    func test_NextButton_ValidData_TriggersNextStep() {
        emailConfirmer.isEmailExists = true
        state.emailTextField.text = "test@example.com"
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        XCTAssertTrue(wasCalled, "Делегат должен быть вызван, если данные валидны.")
    }

    // MARK: - Email TextField

    func test_Email_Valid_NoIncorrectLabelRequested() {
        validator.isValidEmail = true
        emailConfirmer.isEmailExists = false
        state.emailTextField.text = "test@example.com"
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки для валидного email.")
    }

    func test_Email_Exists_IncorrectLabelRequested() {
        emailConfirmer.isEmailExists = true
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel, "Делегат должен запрашивать добавление метки ошибки для невалидного email.")
    }

    func test_Email_NotValid_After_Valid_AddsAndRemovesIncorrectLabel() {

        emailConfirmer.isEmailExists = true
        state.emailTextField.text = "valid@example.com"
        state.nextButtonPressed(nil)
        XCTAssertNil(delegate.lastViewInserted, "Метка ошибки не должна быть добавлена для валидного email.")

        emailConfirmer.isEmailExists = false
        emailConfirmer.errorMessage = "Неверный формат email"
        state.emailTextField.text = "invalid-email"
        state.nextButtonPressed(nil)
        XCTAssertNotNil(delegate.lastViewInserted, "Метка ошибки должна быть добавлена для невалидного email.")

        emailConfirmer.isEmailExists = true
        state.emailTextField.text = "valid2@example.com"
        state.nextButtonPressed(nil)
        
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel, "Метка ошибки должна быть удалена, когда email становится валидным снова.")
    }

    func test_Email_DoubleNotValid_DoesNotAddDoubleLabel() {
        emailConfirmer.isEmailExists = false
        emailConfirmer.errorMessage = "Неверный формат email"
        state.emailTextField.text = "invalid-email"

        state.nextButtonPressed(nil)
        let incorrectLabel1 = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel1, "Метка ошибки должна быть добавлена при первой попытке.")

        delegate.lastViewInserted = nil

        state.nextButtonPressed(nil)
        let incorrectLabel2 = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel2, "Метка ошибки не должна добавляться повторно при повторной попытке с тем же невалидным email.")
    }

    func test_Email_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidEmail = false
        validator.errorMessage = nil
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки, если сообщение об ошибке пустое.")
    }
    
}

fileprivate class MockEmailConfirmer: EmailConfirmer {
    
    var isEmailExists = false
    var errorMessage: String?
    
    func isEmailConsist(_ email: String, completion: ((ValidatorResult) -> ())?) {
        !isEmailExists ? completion?(.valid) : completion?(.invalid(message: ""))
    }
    func confirmEmail(_ email: String, completion: ((ValidatorResult) -> ())?) {}
}
