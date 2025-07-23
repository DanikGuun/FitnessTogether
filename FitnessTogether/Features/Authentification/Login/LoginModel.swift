
import FTDomainData
import Foundation

public protocol LoginModel {
    var motivationTitles: [String] { get }
    func login(userLogin: FTUserLogin, completion: FTCompletion<Data>)
}

public final class BaseLoginModel: LoginModel {
    
    let userInterface: FTUserInterface
    
    public var motivationTitles: [String] = [
        "всякие титлы"
    ]
    
    init(userInterface: FTUserInterface) {
        self.userInterface = userInterface
    }
    
    public func login(userLogin: FTDomainData.FTUserLogin, completion: FTDomainData.FTCompletion<Data>) {
        userInterface.login(data: userLogin, completion: completion)
    }
        
    
    
}
