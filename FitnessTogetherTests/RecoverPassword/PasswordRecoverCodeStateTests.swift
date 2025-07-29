
import XCTest
import FTDomainData
@testable import FitnessTogether

final class PasswordRecoverCodeStateTests: XCTestCase {
    var delegate: MockScreenStateDelegate!
    fileprivate var emailConfirmer: MockEmailConfirmer!
    var state: PasswordRecoverCodeState!

    override func setUp() {
        super.setUp()
        delegate = MockScreenStateDelegate()
        emailConfirmer = MockEmailConfirmer()
        state = PasswordRecoverCodeState(emailConfirmer: emailConfirmer)
        state.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
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

        state.codeTextField.text = "123456" 
        state.checkNextButtonAvailable(nil)

        XCTAssertTrue(state.nextButton.isEnabled, "Кнопка 'Далее' должна стать активной после заполнения кода.")
    }

    func test_NextButton_InactiveAfterEmptyingData() {
        // Сначала заполняем
        state.codeTextField.text = "123456"
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть активна после заполнения.")

        // Потом очищаем
        state.codeTextField.text = ""
        state.checkNextButtonAvailable(nil)

        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна стать неактивной после очистки поля.")
    }

    func test_NextButton_InvalidData_DoesNotTriggerNextStep() {
        emailConfirmer.isCodeValid = false // Настраиваем mock
        emailConfirmer.errorMessage = "Неверный код"
        state.codeTextField.text = "00000" // Неверный код

        state.nextButtonPressed(nil) // Имитируем нажатие кнопки

        XCTAssertFalse(delegate.goNextCalled, "Делегат не должен быть вызван, если код невалиден.")
        XCTAssertTrue(state.codeTextField.isError, "Поле ввода кода должно быть в состоянии ошибки.")
        XCTAssertNotNil(delegate.lastViewInserted, "Должна быть добавлена метка ошибки.")
    }

    func test_NextButton_ValidData_TriggersNextStep() {
        emailConfirmer.isCodeValid = true // Настраиваем mock
        state.codeTextField.text = "12345" // Верный код (по логике MockEmailConfirmer/BaseEmailConfirmer)

        state.nextButtonPressed(nil) // Имитируем нажатие кнопки

        XCTAssertTrue(delegate.goNextCalled, "Делегат должен быть вызван, если код валиден.")
        XCTAssertFalse(state.codeTextField.isError, "Поле ввода кода не должно быть в состоянии ошибки.")
    }

    // MARK: - Code TextField Validation

    func test_Code_Valid_NoIncorrectLabelRequested() {
        emailConfirmer.isCodeValid = true
        state.codeTextField.text = "12345" // Верный код

        state.nextButtonPressed(nil) // Запускаем валидацию

        XCTAssertFalse(state.codeTextField.isError, "Поле не должно быть в состоянии ошибки для валидного кода.")
        XCTAssertNil(delegate.lastViewInserted, "Делегат не должен запрашивать добавление метки ошибки для валидного кода.")
    }

    func test_Code_Invalid_IncorrectLabelRequested() {
        emailConfirmer.isCodeValid = false
        emailConfirmer.errorMessage = "Неверный код подтверждения"
        state.codeTextField.text = "00000" // Неверный код

        state.nextButtonPressed(nil) // Запускаем валидацию

        XCTAssertTrue(state.codeTextField.isError, "Поле должно быть в состоянии ошибки для невалидного кода.")
        XCTAssertNotNil(delegate.lastViewInserted, "Делегат должен запрашивать добавление метки ошибки для невалидного кода.")
    }

    func test_Code_NotValid_After_Valid_AddsAndRemovesIncorrectLabel() {
        // Сначала делаем код валидным
        emailConfirmer.isCodeValid = true
        state.codeTextField.text = "12345"
        state.nextButtonPressed(nil)
        XCTAssertFalse(state.codeTextField.isError, "Поле не должно быть в ошибке для валидного кода.")
        XCTAssertNil(delegate.lastViewInserted, "Метка ошибки не должна быть добавлена для валидного кода.")

        // Затем делаем невалидным
        emailConfirmer.isCodeValid = false
        emailConfirmer.errorMessage = "Неверный код"
        state.codeTextField.text = "00000"
        state.nextButtonPressed(nil)
        XCTAssertTrue(state.codeTextField.isError, "Поле должно быть в ошибке для невалидного кода.")
        XCTAssertNotNil(delegate.lastViewInserted, "Метка ошибки должна быть добавлена для невалидного кода.")

        // Снова делаем валидным
        emailConfirmer.isCodeValid = true
        state.codeTextField.text = "12345"
        state.nextButtonPressed(nil)
        XCTAssertFalse(state.codeTextField.isError, "Поле не должно быть в ошибке после валидации правильного кода.")
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel, "Метка ошибки должна быть удалена, когда код становится валидным снова.")
    }

    func test_Code_DoubleNotValid_DoesNotAddDoubleLabel() {
        emailConfirmer.isCodeValid = false
        emailConfirmer.errorMessage = "Неверный код"
        state.codeTextField.text = "00000"

        state.nextButtonPressed(nil) // Первая попытка с невалидным кодом
        let incorrectLabel1 = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel1, "Метка ошибки должна быть добавлена при первой попытке.")
        delegate.lastViewInserted = nil // Сбрасываем, как в оригинальном тесте

        state.nextButtonPressed(nil) // Вторая попытка с невалидным кодом
        let incorrectLabel2 = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel2, "Метка ошибки не должна добавляться повторно при повторной попытке с тем же невалидным кодом.")
    }

    func test_Code_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        emailConfirmer.isCodeValid = false
        emailConfirmer.errorMessage = nil

        state.nextButtonPressed(nil)

        XCTAssertTrue(state.codeTextField.isError, "Поле должно быть в состоянии ошибки, даже если сообщение пустое.")
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки, если сообщение об ошибке пустое (nil).")
    }
}


