import XCTest
import FTDomainData
@testable import FitnessTogether

final class PasswordRecoverEmailStateTests: XCTestCase {
    var delegate: MockScreenStateDelegate!
    var validator: MockValidator!
    var recoverManager: MockRecoverNetworkManager!
    var state: PasswordRecoverEmailState!

    override func setUp() {
        super.setUp()
        delegate = MockScreenStateDelegate()
        validator = MockValidator()
        recoverManager = MockRecoverNetworkManager()
        state = PasswordRecoverEmailState(validator: validator, recoverManager: recoverManager)
        state.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
        validator = nil
        recoverManager = nil
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
        recoverManager._isEmailExist = true
        state.emailTextField.text = "test@example.com"
        
        state.nextButtonPressed(nil)
        
        let wasCalled = delegate.goNextCalled
        let emailWasSend = recoverManager.sendEmailCodeCalled
        XCTAssertTrue(wasCalled, "Делегат должен быть вызван, если данные валидны.")
        XCTAssertTrue(emailWasSend)
    }

    // MARK: - Email TextField

    func test_Email_Valid_NoIncorrectLabelRequested() {
        validator.isValidEmail = true
        recoverManager._isEmailExist = true
        state.emailTextField.text = "test@example.com"
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки для валидного email.")
    }

    func test_Email_Exists_IncorrectLabelRequested() {
        recoverManager._isEmailExist = true
        
        state.nextButtonPressed(nil)
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки, если почта есть.")
    }

    func test_Email_Valid_After_NotValid_AddsAndRemovesIncorrectLabel() {

        recoverManager._isEmailExist = false
        state.nextButtonPressed(nil)
        XCTAssertNotNil(delegate.lastViewInserted, "Метка ошибки должна быть добавлена для несуществующего email.")

        recoverManager._isEmailExist = true
        recoverManager.errorMessage = "Неверный формат email"
        state.emailTextField.text = "invalid-email"
        state.nextButtonPressed(nil)
        XCTAssertNotNil(delegate.lastViewRemoved, "Метка ошибки должна быть добавлена для невалидного email.")
        
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel, "Метка ошибки должна быть удалена, когда email становится валидным снова.")
    }

    func test_Email_DoubleNotValid_DoesNotAddDoubleLabel() {
        recoverManager._isEmailExist = false
        recoverManager.errorMessage = "Неверный формат email"

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
