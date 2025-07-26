
import FTDomainData
import Foundation
import UIKit

public final class CoachMainModel: BaseMainModel {

    
    public override func workoutsToItems(_ workouts: [FTWorkout], completion: @escaping ([WorkoutItem]) -> Void) {
        
        ftManager.user.getClients(completion: { result in
            switch result {
                
            case .success(let clients):
                let items: [WorkoutItem] = workouts.compactMap { [weak self] workout in
                    guard let self else { return nil }
                    let image = UIImage(systemName: "person.crop.circle")
                    let name = getClientName(workout: workout, clients: clients)
                    let date = workout.startDate ?? Date()
                    let item = WorkoutItem(image: image, name: name, date: date)
                    return item
                }
                completion(items)
                
            case .failure(let error): completion([]); print(error.localizedDescription)
            }
        })
    }
    
    private func getClientName(workout: FTWorkout, clients: [FTUser]) -> String {
        let userId = workout.participants.first(where: { $0.role == .client })?.userId ?? ""
        let user = clients.first(where: { $0.id == userId })
        return user?.firstName ?? ""
    }
    
}
