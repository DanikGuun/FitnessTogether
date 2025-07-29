
import XCTest
@testable import FitnessTogether

class MockEmailConfirmer: EmailConfirmer {
    var isCodeValid: Bool = true
    var isEmailExists: Bool = true
    var errorMessage: String? = "Ошибка валидации кода"

    func confirmEmail(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        isEmailExists ? completion(.invalid(message: errorMessage)) : completion(.valid)
    }

    func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        isEmailExists ? completion(.valid) : completion(.invalid(message: errorMessage)) 
    }

    func isEmailCodeValid(_ code: String, completion: @escaping ((ValidatorResult) -> ())) {
        // В синхронном моке просто вызываем completion немедленно
        let result: ValidatorResult
        if isCodeValid {
            result = .valid
        } else {
            result = .invalid(message: errorMessage)
        }
        completion(result)
    }
}
