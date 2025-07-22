
import Foundation
import XCTest
@testable import FitnessTogether

internal class MockValidator: Validator {
    
    var isValidFirstName = true
    var isValidLastName = true
    var isValidDateOfBirth = true
    var isValidEmail = true
    var isValidPassword = true
    var isValidConfirmPassword = true
    var isValidJobTime = true
    var isValidDescription = true
    var errorMessage: String? = "error"
    
    func isValidFirstName(_ string: String?) -> ValidatorResult {
        return isValidFirstName ? .valid : .invalid(message: errorMessage)
        
    }
    
    func isValidLastName(_ string: String?) -> ValidatorResult {
        return isValidLastName ? .valid : .invalid(message: errorMessage)
    }
    
    func isValidDateOfBirth(_ string: Date?) -> ValidatorResult {
        return isValidDateOfBirth ? .valid : .invalid(message: errorMessage)
    }
    
    func isValidEmail(_ string: String?) -> ValidatorResult {
        return isValidEmail ? .valid : .invalid(message: errorMessage)
    }
    
    func isValidPassword(_ string: String?) -> ValidatorResult {
        return isValidPassword ? .valid : .invalid(message: errorMessage)
    }
    
    func isValidPasswordConfirmation(_ password: String?, _ confirmation: String?) -> ValidatorResult {
        return isValidConfirmPassword ? .valid : .invalid(message: errorMessage)
    }
    
    func isValidJobTime(_ time: Double?) -> ValidatorResult {
        return isValidJobTime ? .valid : .invalid(message: errorMessage)
    }
    
    func isValidDescription(_ string: String?) -> ValidatorResult {
        return isValidDescription ? .valid : .invalid(message: errorMessage)
    }
    
}
