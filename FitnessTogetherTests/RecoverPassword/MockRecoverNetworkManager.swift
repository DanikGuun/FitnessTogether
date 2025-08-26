
import XCTest
@testable import FitnessTogether

final class MockRecoverNetworkManager: PasswordRecoverNetworkManager {
    var _isEmailExist = false
    var _isEmailCodeValid = false
    var sendEmailCodeCalled = false
    var sendEmailCodeAgainCalled = false
    var errorMessage: String? = "error"
    
    func isEmailExist(_ email: String, completion: @escaping ((FitnessTogether.ValidatorResult) -> ())) {
        _isEmailExist ? completion(.valid) : completion(.invalid(message: errorMessage))
    }
    
    func sendEmailCode(_ email: String, completion: @escaping ((FitnessTogether.ValidatorResult) -> ())) {
        sendEmailCodeCalled = true
        completion(.valid)
    }
    
    func sendEmailCodeAgain(completion: ((ValidatorResult) -> ())?) {
        sendEmailCodeAgainCalled = true
    }
    
    func isEmailCodeValid(_ code: String, completion: @escaping ((FitnessTogether.ValidatorResult) -> ())) {
        _isEmailCodeValid ? completion(.valid) : completion(.invalid(message: errorMessage))
    }
    
    
}
