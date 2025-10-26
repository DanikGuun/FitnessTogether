
import FTDomainData

public protocol ProfileModel {
    func getName(completion: @escaping (String?) -> Void)
    func getCoaches(completion: @escaping ([FTClientData]) -> Void)
    func getClients(completion: @escaping ([FTClientData]) -> Void)
    func deleteAccount(completion: @escaping (_ isSuccess: Bool) -> Void)
}

public final class BaseProfileModel: ProfileModel {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getName(completion: @escaping (String?) -> Void) {
        ftManager.user.current(completion: { result in
            switch result {
                
            case .success(let user):
                completion(user.firstName + " " + user.lastName)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    public func getCoaches(completion: @escaping ([FTClientData]) -> Void) {
        ftManager.user.getCoaches(completion: { result in
            switch result {
                
            case .success(let coaches):
                completion(coaches)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func getClients(completion: @escaping ([FTClientData]) -> Void) {
        ftManager.user.getClients(completion: { result in
            switch result {
                
            case .success(let clients):
                completion(clients)
                
            case .failure(let error):
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
    
    public func deleteAccount(completion: @escaping (Bool) -> Void) {
        ftManager.user.deleteAccount(completion: { result in
            switch result {
                
            case .success(_):
                completion(true)
                
            case .failure(let error):
                completion(false)
                print(error.localizedDescription)
                ErrorPresenter.present(error)
            }
        })
    }
}
