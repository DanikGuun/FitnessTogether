
import Foundation

public class BaseValidator: Validator {
    
    public func isValidFirstName(_ string: String?) -> ValidatorResult {
        return string?.count ?? 0 > 1 ? .valid : .invalid(message: "Имя должно быть длиннее 1 символа")
    }
    
    public func isValidLastName(_ string: String?) -> ValidatorResult {
        return string?.count ?? 0 > 1 ? .valid : .invalid(message: "Фамилия должна быть длиннее 1 символа")    }
    
    public func isValidDateOfBirth(_ date: Date?) -> ValidatorResult {
        let interval = date?.distance(to: Date()) ?? 0.0  //возраст
        let minimumAge = 5*365*24*60*60.0
        let maximumAge = 90*365*24*60*60.0
        if interval > minimumAge && interval < maximumAge {
            return .valid
        }
        return .invalid(message: "Вы должны быть старше 5 лет и младше 90 лет")
    }
    
    public func isValidEmail(_ string: String?) -> ValidatorResult {
        let regex = try! Regex("^[a-zA-Z0-9][a-zA-Z0-9._%+-]*@[a-zA-Z0-9][a-zA-Z0-9.-]*\\.[a-zA-Z]{2,64}$")
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
    
    public func isValidWorkExperience(_ time: Double?) -> ValidatorResult {
        guard let time else { return .invalid(message: "Опыт работы не может быть отрицательным") }
        if time > 0 { return .valid }
        return .invalid(message: "Опыт работы не может быть отрицательным")
    }
    
    public func isValidDescription(_ string: String?) -> ValidatorResult {
        let correctLength = string?.count ?? 0 <= 200
        return correctLength ? .valid : .invalid(message: "Длина описания не должна превышать 200 символов")
    }
    
}
