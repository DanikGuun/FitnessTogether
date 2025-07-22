
import Foundation

public protocol Validator {
    
    func isValidFirstName(_ string: String?) -> ValidatorResult
    func isValidLastName(_ string: String?) -> ValidatorResult
    func isValidDateOfBirth(_ string: Date?) -> ValidatorResult
    func isValidEmail(_ string: String?) -> ValidatorResult
    func isValidPassword(_ string: String?) -> ValidatorResult
    func isValidPasswordConfirmation(_ password: String?, _ confirmation: String?) -> ValidatorResult
    func isValidJobTime(_ time: Double?) -> ValidatorResult
    func isValidDescription(_ string: String?) -> ValidatorResult
}

public enum ValidatorResult: Equatable {
    case valid
    case invalid(message: String?)
}
