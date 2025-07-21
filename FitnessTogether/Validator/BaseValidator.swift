
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
        return .valid
    }
    
    public func isValidPassword(_ string: String?) -> ValidatorResult {
        return .valid
    }
    
    
}
