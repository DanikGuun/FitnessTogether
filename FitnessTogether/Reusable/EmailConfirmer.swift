
import Foundation

public protocol EmailConfirmer {
    func confirmEmail(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
}

public final class BaseEmailConfirmer: EmailConfirmer {
    
    public func confirmEmail(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        DispatchQueue.global(qos: .userInitiated).async {
            sleep(1)
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
    
}
