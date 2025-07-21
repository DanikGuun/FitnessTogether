
import Foundation

public class BaseValidator: Validator {
    
    public func isValidFirstName(_ string: String?) -> ValidatorResult {
        return .valid
    }
    
    public func isValidLastName(_ string: String?) -> ValidatorResult {
        return .valid
    }
    
    public func isValidDateOfBirth(_ date: Date?) -> ValidatorResult {
        return .valid
    }
    
    public func isValidEmail(_ string: String?) -> ValidatorResult {
        let regex = try! Regex("[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,64}")
        let isValid = try! regex.wholeMatch(in: string ?? "") != nil
        return isValid ? .valid : .invalid(message: "Неверный формат email")
    }
    
    public func isValidPassword(_ string: String?) -> ValidatorResult {
        let regex = try! Regex("^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#$%^&*()_+\\-=\\[\\]{};':\"\\\\|,.<>\\/?]).{8,}$")
        let isValid = try! regex.wholeMatch(in: string ?? "") != nil
        return isValid ? .valid : .invalid(message: "Пароль должен быть не менее 8 символов, содержать хотя бы одну цифру, одну заглавную букву и один спецсимвол")
    }
    
    public func isValidPasswordConfirmation(_ password: String?, _ confirmation: String?) -> ValidatorResult {
        let isValid = password == confirmation
        return isValid ? .valid : .invalid(message: "Пароли не совпадают")
    }
    
}
