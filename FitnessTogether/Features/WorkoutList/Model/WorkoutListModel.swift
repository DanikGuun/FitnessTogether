
import UIKit
import FTDomainData


public enum AnalyziseMyProgressResult {
    case success
    case serviceError
    case authorizedError
    case notEnoughDataError
    case alreadyAnalysedError
    case unknownError
}

public protocol WorkoutListModel {

    var initialFilterBag: FTFilterBag { get set }
    var currentFilterBag: FTFilterBag { get set }
    func getItems(completion: @escaping ([WorkoutItem]) -> Void)
    func getItems(withFilter filter: FTFilterBag, completion: @escaping ([WorkoutItem]) -> Void)
    func analyziseMyProgress(completion: @escaping (AnalyziseMyProgressResult) -> Void)
}

public class BaseWorkoutListModel: WorkoutListModel {
    public var initialFilterBag: FTFilterBag = FTFilterBag(dateInterval: .toEndOfWeek)
    public var currentFilterBag: FTFilterBag = FTFilterBag(dateInterval: .toEndOfWeek)
    var role: FTUserRole { .coach }
    let ftManager: FTManager
    var refDate = Date()
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getItems(completion: @escaping ([WorkoutItem]) -> Void) {
        getItems(withFilter: currentFilterBag, completion: completion)
    }
    
    public func getItems(withFilter filter: FTFilterBag, completion: @escaping ([WorkoutItem]) -> Void) {
        getNearestWorkouts(filter: filter, completion: { [weak self] workouts in
            guard let self else { return }
            
            workoutsToItems(workouts, completion: completion)
            
        })
    }
    
    //To override
    public func workoutsToItems(_ workouts: [FTWorkout], completion: @escaping ([WorkoutItem]) -> Void) {
        completion([])
    }
    
    internal func getNearestWorkouts(filter: FTFilterBag, completion: @escaping ([FTWorkout]) -> Void) {
        ftManager.user.current(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let user):
                
                getFilteredWorkouts(coach: user, filter: filter, completion: { workouts in
                    let sorted = workouts.sorted(by: { ($0.startDate ?? Date()) < ($1.startDate ?? Date()) })
                    completion(sorted)
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                ErrorPresenter.present(error)
            }
        })
    }
    
    private func getFilteredWorkouts(coach: FTUser, filter: FTFilterBag, completion: @escaping ([FTWorkout]) -> Void) {
        ftManager.workout.getAll(completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(let workouts):
                
                let filteredWorkouts = filterWorkouts(workouts, filter: filter, user: coach)
                completion(filteredWorkouts)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
                ErrorPresenter.present(error)
            }
            
        })
    }
    
    public func analyziseMyProgress(completion: @escaping (AnalyziseMyProgressResult) -> Void) {
        ftManager.workoutAnalysis.post { result in
            switch result {
            case .success():
                completion(.success)

            case .failure(let error):
                print(error.localizedDescription)
                
                switch error {
                case .networkError(let code, _):
                    switch code {
                    case 400: completion(.serviceError)
                    case 401: completion(.authorizedError)
                    case 404: completion(.notEnoughDataError)
                    case 409: completion(.alreadyAnalysedError)
                    default: ErrorPresenter.present(error)
                    }
                case .serverError(_): // Http Status Code - 500
                    completion(.serviceError)
                    
                default: completion(.unknownError)
                }
            }
        }
    }
    
    internal func filterWorkouts(_ workouts: [FTWorkout], filter: FTFilterBag, user: FTUser) -> [FTWorkout] {

        return workouts.filter { [weak self] workout in
            guard let self else { return false }
            
            // TODO: Ждём правки на стороне API, https://ru.yougile.com/team/60c344d10c22/FitnessTogether#FT-41
            guard let role = workout.participants?.first(where: { $0.userId == user.id })?.role else { return false }
            return role.userRole == self.role && //чтобы роль совпадала
                    filter.shouldInclude(workout)
            
            return filter.shouldInclude(workout)
        }
    }
}
