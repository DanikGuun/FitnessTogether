import XCTest
@testable import FitnessTogether

class BaseValidatorTests: XCTestCase {
    
    var validator: BaseValidator!
    
    override func setUp() {
        super.setUp()
        validator = BaseValidator()
    }
    
    override func tearDown() {
        validator = nil
        super.tearDown()
    }
    
    // MARK: - First Name
    
    func test_FirstName_Valid() {
        let result = validator.isValidFirstName("Иван")
        XCTAssertEqual(result, .valid)
    }
    
    func test_FirstName_TwoChars() {
        let result = validator.isValidFirstName("Ал")
        XCTAssertEqual(result, .valid)
    }
    
    func test_FirstName_OneChar() {
        let result = validator.isValidFirstName("А")
        XCTAssertEqual(result, .invalid(message: "Имя должно быть длиннее 1 символа"))
    }
    
    func test_FirstName_Empty() {
        let result = validator.isValidFirstName("")
        XCTAssertEqual(result, .invalid(message: "Имя должно быть длиннее 1 символа"))
    }
    
    func test_FirstName_Nil() {
        let result = validator.isValidFirstName(nil)
        XCTAssertEqual(result, .invalid(message: "Имя должно быть длиннее 1 символа"))
    }
    
    // MARK: - Last Name
    
    func test_LastName_Valid() {
        let result = validator.isValidLastName("Сидоров")
        XCTAssertEqual(result, .valid)
    }
    
    func test_LastName_TwoChars() {
        let result = validator.isValidLastName("Зу")
        XCTAssertEqual(result, .valid)
    }
    
    func test_LastName_OneChar() {
        let result = validator.isValidLastName("А")
        XCTAssertEqual(result, .invalid(message: "Фамилия должна быть длиннее 1 символа"))
    }
    
    func test_LastName_Empty() {
        let result = validator.isValidLastName("")
        XCTAssertEqual(result, .invalid(message: "Фамилия должна быть длиннее 1 символа"))
    }
    
    func test_LastName_Nil() {
        let result = validator.isValidLastName(nil)
        XCTAssertEqual(result, .invalid(message: "Фамилия должна быть длиннее 1 символа"))
    }
    
    // MARK: - Date of Birth
    
    func test_DateOfBirth_Valid_25YearsOld() {
        let date = Calendar.current.date(byAdding: .year, value: -25, to: Date())!
        let result = validator.isValidDateOfBirth(date)
        XCTAssertEqual(result, .valid)
    }
    
    func test_DateOfBirth_Valid_6YearsOld() {
        let date = Calendar.current.date(byAdding: .year, value: -6, to: Date())!
        let result = validator.isValidDateOfBirth(date)
        XCTAssertEqual(result, .valid)
    }
    
    func test_DateOfBirth_Invalid_Under5Years() {
        let date = Calendar.current.date(byAdding: .year, value: -4, to: Date())!
        let result = validator.isValidDateOfBirth(date)
        XCTAssertEqual(result, .invalid(message: "Вы должны быть старше 5 лет и младше 90 лет"))
    }
    
    func test_DateOfBirth_Invalid_Over90Years() {
        let date = Calendar.current.date(byAdding: .year, value: -95, to: Date())!
        let result = validator.isValidDateOfBirth(date)
        XCTAssertEqual(result, .invalid(message: "Вы должны быть старше 5 лет и младше 90 лет"))
    }
    
    func test_DateOfBirth_Nil() {
        let result = validator.isValidDateOfBirth(nil)
        XCTAssertEqual(result, .invalid(message: "Вы должны быть старше 5 лет и младше 90 лет"))
    }
    
    // MARK: - Email
    
    func test_Email_Valid_Simple() {
        let result = validator.isValidEmail("user@example.com")
        XCTAssertEqual(result, .valid)
    }
    
    func test_Email_Valid_WithDot() {
        let result = validator.isValidEmail("test.user@domain.co.uk")
        XCTAssertEqual(result, .valid)
    }
    
    func test_Email_Invalid_MissingAt() {
        let result = validator.isValidEmail("userexample.com")
        XCTAssertEqual(result, .invalid(message: "Неверный формат email"))
    }
    
    func test_Email_Invalid_DoubleAt() {
        let result = validator.isValidEmail("user@@example.com")
        XCTAssertEqual(result, .invalid(message: "Неверный формат email"))
    }
    
    func test_Email_Invalid_NoDotAfterAt() {
        let result = validator.isValidEmail("user@domain")
        XCTAssertEqual(result, .invalid(message: "Неверный формат email"))
    }
    
    func test_Email_Invalid_StartWithDot() {
        let result = validator.isValidEmail(".user@example.com")
        XCTAssertEqual(result, .invalid(message: "Неверный формат email"))
    }
    
    func test_Email_Nil() {
        let result = validator.isValidEmail(nil)
        XCTAssertEqual(result, .invalid(message: "Неверный формат email"))
    }
    
    func test_Email_Empty() {
        let result = validator.isValidEmail("")
        XCTAssertEqual(result, .invalid(message: "Неверный формат email"))
    }
    
    // MARK: - Password
    
    func test_Password_Valid() {
        let result = validator.isValidPassword("Password1!")
        XCTAssertEqual(result, .valid)
    }
    
    func test_Password_Invalid_TooShort() {
        let result = validator.isValidPassword("Pass1!")
        XCTAssertEqual(result, .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол"))
    }
    
    func test_Password_Invalid_NoUppercase() {
        let result = validator.isValidPassword("password1!")
        XCTAssertEqual(result, .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол"))
    }
    
    func test_Password_Invalid_NoDigit() {
        let result = validator.isValidPassword("Password!")
        XCTAssertEqual(result, .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол"))
    }
    
    func test_Password_Invalid_NoSpecialChar() {
        let result = validator.isValidPassword("Password1")
        XCTAssertEqual(result, .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол"))
    }
    
    func test_Password_Nil() {
        let result = validator.isValidPassword(nil)
        XCTAssertEqual(result, .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол"))
    }
    
    func test_Password_Empty() {
        let result = validator.isValidPassword("")
        XCTAssertEqual(result, .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол"))
    }
    
    // MARK: - Password Confirmation
    
    func test_PasswordConfirmation_Valid_Match() {
        let result = validator.isValidPasswordConfirmation("Pass123!", "Pass123!")
        XCTAssertEqual(result, .valid)
    }
    
    func test_PasswordConfirmation_Invalid_Mismatch() {
        let result = validator.isValidPasswordConfirmation("Pass123!", "Pass123?")
        XCTAssertEqual(result, .invalid(message: "Пароли не совпадают"))
    }
    
    func test_PasswordConfirmation_Valid_BothNil() {
        let result = validator.isValidPasswordConfirmation(nil, nil)
        XCTAssertEqual(result, .valid)
    }
    
    func test_PasswordConfirmation_Invalid_OneNil() {
        let result = validator.isValidPasswordConfirmation("Pass123!", nil)
        XCTAssertEqual(result, .invalid(message: "Пароли не совпадают"))
    }
    
    func test_PasswordConfirmation_Invalid_OtherNil() {
        let result = validator.isValidPasswordConfirmation(nil, "Pass123!")
        XCTAssertEqual(result, .invalid(message: "Пароли не совпадают"))
    }
    
    // MARK: - Work Experience
    
    func test_WorkExperience_Valid_Positive() {
        let result = validator.isValidWorkExperience(1.5)
        XCTAssertEqual(result, .valid)
    }
    
    func test_WorkExperience_Invalid_Zero() {
        let result = validator.isValidWorkExperience(0)
        XCTAssertEqual(result, .invalid(message: "Опыт работы не может быть отрицательным"))
    }
    
    func test_WorkExperience_Invalid_Negative() {
        let result = validator.isValidWorkExperience(-1)
        XCTAssertEqual(result, .invalid(message: "Опыт работы не может быть отрицательным"))
    }
    
    func test_WorkExperience_Nil() {
        let result = validator.isValidWorkExperience(nil)
        XCTAssertEqual(result, .invalid(message: "Опыт работы не может быть отрицательным"))
    }
    
    // MARK: - Description
    
    func test_Description_Valid_Empty() {
        let result = validator.isValidDescription("")
        XCTAssertEqual(result, .valid)
    }
    
    func test_Description_Valid_200Chars() {
        let string = String(repeating: "A", count: 200)
        let result = validator.isValidDescription(string)
        XCTAssertEqual(result, .valid)
    }
    
    func test_Description_Invalid_201Chars() {
        let string = String(repeating: "A", count: 201)
        let result = validator.isValidDescription(string)
        XCTAssertEqual(result, .invalid(message: "Длина описания не должна превышать 200 символов"))
    }
    
    func test_Description_Valid_1Char() {
        let result = validator.isValidDescription("A")
        XCTAssertEqual(result, .valid)
    }
    
    func test_Description_Nil() {
        let result = validator.isValidDescription(nil)
        XCTAssertEqual(result, .valid) // потому что (nil?.count ?? 0) = 0 <= 200
    }
    
}
