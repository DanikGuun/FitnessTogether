
import Foundation
import FTDomainData

public protocol PasswordRecoverNetworkManager {
    func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
    func sendEmailCode(_ email: String, completion: @escaping ((ValidatorResult) -> ()))
    func sendEmailCodeAgain(completion: ((ValidatorResult) -> ())?)
    func isEmailCodeValid(_ code: String, completion: @escaping ((ValidatorResult) -> ()))
}

public class PasswordRecoverNetwork: PasswordRecoverNetworkManager {
    
    let ftManager: any FTManager
    
    private var email: String = ""
    private var resetCode: String = ""
    
    init(ftManager: any FTManager) {
        self.ftManager = ftManager
    }
    
    public func isEmailExist(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        completion(.valid)
    }
    
    public func sendEmailCode(_ email: String, completion: @escaping ((ValidatorResult) -> ())) {
        self.email = email
        let data = FTForgotPasswordEmail(email: email)
        
        ftManager.email.forgotPassword(data: data, completion: { [weak self] result in
            switch result {
                
            case .success(let reset):
                self?.resetCode = reset.resetCode
                completion(.valid)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(.invalid(message: "Ошибка отправки кода, повторите попытку позже"))
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func sendEmailCodeAgain(completion: ((ValidatorResult) -> ())?) {
        let data = FTForgotPasswordEmail(email: email)
        
        ftManager.email.forgotPassword(data: data, completion: { [weak self] result in
            switch result {
                
            case .success(let reset):
                self?.resetCode = reset.resetCode
                completion?(.valid)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion?(.invalid(message: "Ошибка отправки кода, повторите попытку позже"))
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func isEmailCodeValid(_ code: String, completion: @escaping ((ValidatorResult) -> ())) {
        guard code == resetCode else {
            completion(.invalid(message: "Неверный код"))
            return
        }
        completion(.valid)
    }
    
}
