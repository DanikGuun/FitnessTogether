
import UIKit
import FTDomainData

public protocol CoachMainModel {
    func getItems(completion: @escaping ([CoachTrainItem]) -> Void)
}

public final class BaseCoachMainModel: CoachMainModel {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getItems(completion: @escaping ([CoachTrainItem]) -> Void) {
        
        ftManager.user.getClients(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let clients):
                
                getNearestWorkouts(completion: { workouts in
                    let items = self.workoutsToItems(workouts, clients: clients)
                    completion(items)
                })
                
            case .failure(let error):
                print(error.description)
                completion([])
            }
        })
        

    }
    
    private func workoutsToItems(_ workouts: [FTWorkout], clients: [FTUser]) -> [CoachTrainItem] {
        let items: [CoachTrainItem] = workouts.compactMap { [weak self] workout in
            guard let self else { return nil }
            let image = UIImage(systemName: "person.crop.circle")
            let name = getClientName(workout: workout, clients: clients)
            let date = workout.startDate ?? Date()
            let item = CoachTrainItem(image: image, name: name, date: date)
            return item
        }
        return items
    }
    
    private func getClientName(workout: FTWorkout, clients: [FTUser]) -> String {
        let userId = workout.participants.first(where: { $0.role == .client })?.userId ?? ""
        let user = clients.first(where: { $0.id == userId })
        return user?.firstName ?? ""
    }
    
    private func getNearestWorkouts(completion: @escaping ([FTWorkout]) -> Void) {
        ftManager.user.current(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                
                getFilteredWorkouts(coach: user, completion: { workouts in
                    let sorted = workouts.sorted(by: { ($0.startDate ?? Date()) < ($1.startDate ?? Date()) })
                    completion(sorted)
                })
                
            case .failure(let error):
                print(error.description)
                completion([])
            }
        })
    }
    
    private func getFilteredWorkouts(coach: FTUser, completion: @escaping ([FTWorkout]) -> Void) {
        ftManager.workout.getAll(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let workouts):
                
                let filteredWorkouts = filterWorkouts(workouts, coach: coach)
                completion(filteredWorkouts)
                
            case .failure(let error):
                print(error.description)
                completion([])
            }
            
        })
    }
    
    private func filterWorkouts(_ workouts: [FTWorkout], coach: FTUser) -> [FTWorkout] {
        var interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
        interval.start = Date().addingTimeInterval(-2 * 3600)
        return workouts.filter { workout in
            workout.participants.first(where: { $0.userId == coach.id })?.role == .coach && //чтобы был тренер
            interval.contains(workout.startDate ?? Date())
        }
    }
    
}
