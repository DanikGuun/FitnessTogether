
import FTDomainData

public protocol SetListModel {
    var exerciseId: String { get }
    func getSets(completion: @escaping ([FTSet]) -> Void)
}

public final class BaseSetListModel: SetListModel {
    
    let ftManager: any FTManager
    public let exerciseId: String
    
    public init(ftManager: any FTManager, exerciseId: String) {
        self.ftManager = ftManager
        self.exerciseId = exerciseId
    }
    
    public func getSets(completion: @escaping ([FTSet]) -> Void) {
        ftManager.set.get(exerciseId: exerciseId, completion: { result in
            switch result {
                
            case .success(let sets):
                completion(sets)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        })
        
    }
    
}
