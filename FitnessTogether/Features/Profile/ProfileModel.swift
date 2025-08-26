
import FTDomainData

public protocol ProfileModel {
    func getCoaches(completion: @escaping ([FTUser]) -> Void)
    func getClients(completion: @escaping ([FTUser]) -> Void)
}

public final class BaseProfileModel: ProfileModel {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getCoaches(completion: @escaping ([FTUser]) -> Void) {
        ftManager.user.getCoaches(completion: { result in
            switch result {
                
            case .success(let coaches):
                completion(coaches)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    public func getClients(completion: @escaping ([FTUser]) -> Void) {
        ftManager.user.getClients(completion: { result in
            switch result {
                
            case .success(let clients):
                completion(clients)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}
