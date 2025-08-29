
public protocol AddToCoachModel {
    func getId(completion: @escaping (String) -> Void)
}

public final class BaseAddToCoachModel: AddToCoachModel {
    
    let ftManager: FTManager
    
    init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getId(completion: @escaping (String) -> Void) {
        ftManager.user.current(completion: { result in
            switch result {
                
            case .success(let user):
                completion(user.id)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
}
