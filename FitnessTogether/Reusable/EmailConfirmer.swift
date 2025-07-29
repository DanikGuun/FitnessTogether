
import Foundation

public protocol EmailConfirmer {
    func confirmEmail(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
    func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
    func isEmailCodeValid(_ code: String, completion: @escaping ((ValidatorResult) -> ()))
}

public final class BaseEmailConfirmer: EmailConfirmer {
    
    public func confirmEmail(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(3)
            DispatchQueue.main.sync {
                if email != "bondardanya10@gmail.com" {
                    completion(.valid)
                }
                else {
                    completion(.invalid(message: "Данная почта уже используется"))
                }
            }
        }
    }
    
    public func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.sync {
                completion(.valid)
            }
        }
    }
    
    public func isEmailCodeValid(_ code: String, completion: @escaping ((ValidatorResult) -> ())) {
        let isValid = code == "12345"
        let result = isValid ? ValidatorResult.valid : .invalid(message: "Неверный код")
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.sync {
                completion(result)
            }
        }
    }
    
}
