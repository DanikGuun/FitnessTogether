
import FTDomainData
import Foundation

public protocol LoginModel {
    func login(userLogin: FTUserLogin, completion: FTCompletion<Data>)
}

public final class BaseLoginModel: LoginModel {
    
    let userInterface: FTUserInterface
    
    init(userInterface: FTUserInterface) {
        self.userInterface = userInterface
    }
    
    public func login(userLogin: FTDomainData.FTUserLogin, completion: FTDomainData.FTCompletion<Data>) {
        userInterface.login(data: userLogin, completion: completion)
    }
        
    
    
}
