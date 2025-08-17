
import FTDomainData

public protocol ClientProvider {
    func getClients(completion: @escaping (([FTUser]) -> Void))
}

public final class FTUserAdapterClientProvider: ClientProvider {
    
    let ftUser: any FTUserInterface
    
    init(ftUser: any FTUserInterface) {
        self.ftUser = ftUser
    }
    
    public func getClients(completion: @escaping (([FTUser]) -> Void)) {
        ftUser.getClients { result in
            switch result {
                
            case .success(let users):
                completion(users)
                
            case .failure(let error):
                print("FTUserAdapterClientProvider " + error.localizedDescription)
            }
        }
    }
    
}
