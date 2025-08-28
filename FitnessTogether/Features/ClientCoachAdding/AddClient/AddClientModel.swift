
import FTDomainData

public protocol AddClientModel {
    func getUserById(id: String, completion: @escaping (FTClientData?) -> Void)
    func addClient(id: String, completion: ((Result<Void, Error>) -> Void)?)
}

public final class BaseAddClientModel: AddClientModel {
    
    let ftManager: FTManager
    
    init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getUserById(id: String, completion: @escaping (FTClientData?) -> Void) {
        ftManager.user.get(id: id, completion: { result in
            switch result {
                
            case .success(let user):
                completion(user)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion(nil)
            }
        })
    }
    
    public func addClient(id: String, completion: ((Result<Void, Error>) -> Void)?) {
        ftManager.user.addClientToCoach(clientId: id, completion: { result in
            switch result {
                
            case .success(_):
                completion?(.success(()))
                
            case .failure(let error):
                completion?(.failure(error))
                print(error.localizedDescription)
            }
        })
    }
    
}
