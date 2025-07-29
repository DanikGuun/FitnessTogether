
import XCTest
import FTDomainData
@testable import FitnessTogether

final class PasswordRecoverNewPasswordStateTests: XCTestCase {
    var delegate: MockScreenStateDelegate!
    var validator: MockValidator!
    var state: PasswordRecoverNewPasswordState!

    override func setUp() {
        super.setUp()
        delegate = MockScreenStateDelegate()
        validator = MockValidator()
        state = PasswordRecoverNewPasswordState(validator: validator)
        state.delegate = delegate
    }

    override func tearDown() {
        delegate = nil
        validator = nil
        state = nil
        super.tearDown()
    }

    // MARK: - Next Button

    func test_NextButton_StartInactive() {
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть неактивна при старте, если поля пусты.")
    }

    func test_NextButton_ActiveAfterFullData() {
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть неактивна изначально.")
        
        state.passwordTextField.text = "password123"
        state.checkNextButtonAvailable(nil) // Имитируем изменение текста
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна оставаться неактивной, если заполнено только одно поле.")

        state.confirmPasswordTextField.text = "password123"
        state.checkNextButtonAvailable(nil) // Имитируем изменение текста
        
        XCTAssertTrue(state.nextButton.isEnabled, "Кнопка 'Далее' должна стать активной после заполнения обоих полей.")
    }

    func test_NextButton_InactiveAfterEmptyingData() {
        state.passwordTextField.text = "password123"
        state.confirmPasswordTextField.text = "password123"
        state.checkNextButtonAvailable(nil)
        XCTAssertTrue(state.nextButton.isEnabled, "Кнопка 'Далее' должна быть активна после заполнения.")

        state.passwordTextField.text = ""
        state.checkNextButtonAvailable(nil)
        
        XCTAssertFalse(state.nextButton.isEnabled, "Кнопка 'Далее' должна стать неактивной после очистки одного из полей.")
    }

    func test_NextButton_InvalidData_DoesNotTriggerNextStep() {
        validator.isValidPassword = false // Делаем пароль невалидным
        state.passwordTextField.text = "123" // Невалидный пароль
        state.confirmPasswordTextField.text = "123" // Подтверждение совпадает

        state.nextButtonPressed(nil) // Имитируем нажатие кнопки
        
        let wasCalled = delegate.goNextCalled
        XCTAssertFalse(wasCalled, "Делегат не должен быть вызван, если данные невалидны.")
    }

    func test_NextButton_ValidData_TriggersNextStep() {
        validator.isValidPassword = true
        validator.isValidConfirmPassword = true
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "validPassword123"
        
        state.nextButtonPressed(nil) // Имитируем нажатие кнопки
        
        let wasCalled = delegate.goNextCalled
        XCTAssertTrue(wasCalled, "Делегат должен быть вызван, если данные валидны.")
    }

    // MARK: - Password TextField

    func test_Password_Valid_NoIncorrectLabelRequested() {
        validator.isValidPassword = true
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "validPassword123"
        
        state.nextButtonPressed(nil) // Запускаем валидацию
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки для валидного пароля.")
    }

    func test_Password_Invalid_IncorrectLabelRequested() {
        validator.isValidPassword = false
        validator.errorMessage = "Пароль слишком короткий"
        state.passwordTextField.text = "123" // Невалидный пароль
        state.confirmPasswordTextField.text = "123"
        
        state.nextButtonPressed(nil) // Запускаем валидацию
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel, "Делегат должен запрашивать добавление метки ошибки для невалидного пароля.")
    }

    func test_Password_NotValid_After_Valid_AddsAndRemovesIncorrectLabel() {
        // Сначала делаем пароль валидным
        validator.isValidPassword = true
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "validPassword123"
        state.nextButtonPressed(nil)
        XCTAssertNil(delegate.lastViewInserted, "Метка ошибки не должна быть добавлена для валидного пароля.")

        // Затем делаем невалидным
        validator.isValidPassword = false
        validator.errorMessage = "Пароль слишком короткий"
        state.passwordTextField.text = "123"
        state.confirmPasswordTextField.text = "123"
        state.nextButtonPressed(nil)
        XCTAssertNotNil(delegate.lastViewInserted, "Метка ошибки должна быть добавлена для невалидного пароля.")

        // Снова делаем валидным
        validator.isValidPassword = true
        state.passwordTextField.text = "anotherValidPassword123"
        state.confirmPasswordTextField.text = "anotherValidPassword123"
        state.nextButtonPressed(nil)
        
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel, "Метка ошибки должна быть удалена, когда пароль становится валидным снова.")
    }

    func test_Password_DoubleNotValid_DoesNotAddDoubleLabel() {
        validator.isValidPassword = false
        validator.errorMessage = "Пароль слишком короткий"
        state.passwordTextField.text = "123"
        state.confirmPasswordTextField.text = "123"

        state.nextButtonPressed(nil) // Первая попытка с невалидным паролем
        let incorrectLabel1 = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel1, "Метка ошибки должна быть добавлена при первой попытке.")

        delegate.lastViewInserted = nil // Сбрасываем, как в оригинальном тесте

        state.nextButtonPressed(nil) // Вторая попытка с невалидным паролем
        let incorrectLabel2 = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel2, "Метка ошибки не должна добавляться повторно при повторной попытке с тем же невалидным паролем.")
    }

    func test_Password_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
        validator.isValidPassword = false
        validator.errorMessage = nil // Важное отличие - сообщение об ошибке nil
        state.passwordTextField.text = "123"
        state.confirmPasswordTextField.text = "123"
        
        state.nextButtonPressed(nil) // Запускаем валидацию
        
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки, если сообщение об ошибке пустое.")
    }

    // MARK: - Confirm Password TextField

    func test_ConfirmPassword_Valid_NoIncorrectLabelRequested() {
        validator.isValidPassword = true // Основной пароль валиден
        validator.isValidConfirmPassword = true // Подтверждение валидно
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "validPassword123" // Совпадает
        
        state.nextButtonPressed(nil) // Запускаем валидацию
        
        // Предполагаем, что ошибка отображается на поле подтверждения
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки для валидного подтверждения пароля.")
    }

    func test_ConfirmPassword_Invalid_IncorrectLabelRequested() {
        validator.isValidPassword = true // Основной пароль валиден
        validator.isValidConfirmPassword = false // Подтверждение НЕ валидно
        validator.errorMessage = "Пароли не совпадают"
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "differentPassword123" // Не совпадает
        
        state.nextButtonPressed(nil) // Запускаем валидацию
        
        // Предполагаем, что ошибка отображается на поле подтверждения
        let incorrectLabel = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel, "Делегат должен запрашивать добавление метки ошибки для невалидного подтверждения пароля.")
    }

    func test_ConfirmPassword_NotValid_After_Valid_AddsAndRemovesIncorrectLabel() {
        // Сначала делаем подтверждение валидным
        validator.isValidPassword = true
        validator.isValidConfirmPassword = true
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "validPassword123"
        state.nextButtonPressed(nil)
        XCTAssertNil(delegate.lastViewInserted, "Метка ошибки не должна быть добавлена для валидного подтверждения.")

        // Затем делаем невалидным (не совпадает)
        validator.isValidConfirmPassword = false
        validator.errorMessage = "Пароли не совпадают"
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "wrongConfirmation"
        state.nextButtonPressed(nil)
        XCTAssertNotNil(delegate.lastViewInserted, "Метка ошибки должна быть добавлена для невалидного подтверждения.")

        // Снова делаем валидным (совпадает)
        validator.isValidConfirmPassword = true
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "validPassword123"
        state.nextButtonPressed(nil)
        
        let removedLabel = delegate.lastViewRemoved
        XCTAssertNotNil(removedLabel, "Метка ошибки должна быть удалена, когда подтверждение становится валидным снова.")
    }

    func test_ConfirmPassword_DoubleNotValid_DoesNotAddDoubleLabel() {
        validator.isValidPassword = true
        validator.isValidConfirmPassword = false
        validator.errorMessage = "Пароли не совпадают"
        state.passwordTextField.text = "validPassword123"
        state.confirmPasswordTextField.text = "wrongConfirmation"

        state.nextButtonPressed(nil) // Первая попытка с невалидным подтверждением
        let incorrectLabel1 = delegate.lastViewInserted
        XCTAssertNotNil(incorrectLabel1, "Метка ошибки должна быть добавлена при первой попытке.")

        delegate.lastViewInserted = nil // Сбрасываем, как в оригинальном тесте

        state.nextButtonPressed(nil) // Вторая попытка с невалидным подтверждением
        let incorrectLabel2 = delegate.lastViewInserted
        XCTAssertNil(incorrectLabel2, "Метка ошибки не должна добавляться повторно при повторной попытке с тем же невалидным подтверждением.")
    }

     func test_ConfirmPassword_NotValid_EmptyErrorMessage_DelegateNotRequestToAddIncorrectLabel() {
         validator.isValidPassword = true
         validator.isValidConfirmPassword = false
         validator.errorMessage = nil // Важное отличие - сообщение об ошибке nil
         state.passwordTextField.text = "validPassword123"
         state.confirmPasswordTextField.text = "wrongConfirmation"
         
         state.nextButtonPressed(nil) // Запускаем валидацию
         
         let incorrectLabel = delegate.lastViewInserted
         XCTAssertNil(incorrectLabel, "Делегат не должен запрашивать добавление метки ошибки, если сообщение об ошибке пустое.")
     }
}
