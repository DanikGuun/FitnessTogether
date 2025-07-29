
import Foundation

public protocol PasswordRecoverNetworkManager {
    func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
    func sendEmailCode(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
    func sendEmailCodeAgain(completion: ((ValidatorResult) -> ())?)
    func isEmailCodeValid(_ code: String, completion: @escaping ((ValidatorResult) -> ()))
}

public class PasswordRecoverNetwork: PasswordRecoverNetworkManager {
    
    public func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.sync {
                completion(.valid)
            }
        }
    }
    
    public func sendEmailCode(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.sync {
                completion(.valid)
            }
        }
    }
    
    public func sendEmailCodeAgain(completion: ((ValidatorResult) -> ())?) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
            DispatchQueue.main.sync {
                completion?(.valid)
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
