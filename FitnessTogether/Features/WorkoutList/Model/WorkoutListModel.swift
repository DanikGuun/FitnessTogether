
import UIKit
import FTDomainData

public protocol WorkoutListModel {
    var additionalFilter: ((FTWorkout) -> Bool) { get set }
    func getItems(completion: @escaping ([WorkoutItem]) -> Void)
}

public class BaseWorkoutListModel: WorkoutListModel {
    
    var role: FTUserRole { .coach }
    let ftManager: FTManager
    var refDate = Date()
    
    public var additionalFilter: ((FTWorkout) -> Bool) = { _ in true}
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getItems(completion: @escaping ([WorkoutItem]) -> Void) {
        getNearestWorkouts(completion: { [weak self] workouts in
            guard let self else { return }
            
            workoutsToItems(workouts, completion: completion)
            
        })
    }
    
    //To override
    public func workoutsToItems(_ workouts: [FTWorkout], completion: @escaping ([WorkoutItem]) -> Void) {
        completion([])
    }
    
    internal func getNearestWorkouts(completion: @escaping ([FTWorkout]) -> Void) {
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
                
                let filteredWorkouts = filterWorkouts(workouts, user: coach)
                completion(filteredWorkouts)
                
            case .failure(let error):
                print(error.description)
                completion([])
            }
            
        })
    }
    
    internal func filterWorkouts(_ workouts: [FTWorkout], user: FTUser) -> [FTWorkout] {

        return workouts.filter { [weak self] workout in
            guard let self else { return false }
            guard let role = workout.participants.first(where: { $0.userId == user.id })?.role else { return false }
            return role.userRole == self.role && //чтобы роль совпдала
            additionalFilter(workout)
        }
    }
}
