
import FTDomainData

public protocol SetListModel {
    var exerciseId: String { get }
    func getSets(completion: @escaping ([FTSet]) -> Void)
    func saveSets(_ sets: [SetCollectionItem], completion: @escaping (Result<Void, any Error>) -> Void)
    func getExerciseName(completion: @escaping (String) -> Void)
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
    
    public func saveSets(_ sets: [SetCollectionItem], completion: @escaping (Result<Void, any Error>) -> Void) {
        
        var isSuccess = true
        
        for item in sets {
            let createItem = FTSetCreate(number: item.number, amount: item.count, weight: item.weight, exerciseId: exerciseId)
            if let id = item.id { editSet(createItem, setId: id, flag: &isSuccess) }
            else { createSet(createItem, flag: &isSuccess) }
        }
        
        //TODO: Сделать норм потом
        completion(.success(()))
    }
    
    private func createSet(_ set: FTSetCreate, flag: inout Bool) {
        ftManager.set.create(data: set, completion: { result in
            switch result {
                
            case .success(_):
                return
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func editSet(_ set: FTSetCreate, setId: String, flag: inout Bool) {
        ftManager.set.edit(setId: setId, newData: set, completion: nil)
    }
    
    private func setCollectionItemsToCreate(_ items: [SetCollectionItem]) -> [FTSetCreate] {
        var createItems: [FTSetCreate] = []
        
        for item in items {
            let item = FTSetCreate(number: item.number, amount: item.count, weight: item.weight, exerciseId: exerciseId)
            createItems.append(item)
        }
        
        return createItems
    }
    
    public func getExerciseName(completion: @escaping (String) -> Void) {
        ftManager.exercise.get(exerciseId: exerciseId, completion: { result in
            switch result {
                
            case .success(let exercise):
                completion(exercise.name)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion("Нет Названия")
            }
        })
    }
    
}
