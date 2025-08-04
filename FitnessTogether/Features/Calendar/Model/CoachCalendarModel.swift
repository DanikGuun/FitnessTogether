
import Foundation
import FTDomainData

public final class CoachCalendarModel: CalendarModel {
    
    let ftManager: FTManager
    
    public init(ftManager: FTManager) {
        self.ftManager = ftManager
    }
    
    public func getItems(for interval: DateInterval, completion: @escaping ([WorkoutTimelineItem]) -> Void) {
        ftManager.user.current(completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let user):
                getWorkouts(user: user, for: interval, completion: { workouts in
                    self.workoutsToItems(workouts, completion: { items in
                        completion(items)
                    })
                })
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        })
    }
    
    private func getWorkouts(user: FTUser, for interval: DateInterval, completion: @escaping ([FTWorkout]) -> Void) {
        ftManager.workout.getAll(completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let workouts):
                let filtered = filterWorkouts(workouts, user: user, for: interval)
                completion(filtered)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        })
    }
    
    private func filterWorkouts(_ workouts: [FTWorkout], user: FTUser, for interval: DateInterval) -> [FTWorkout] {
        let filteredWorkouts = workouts.filter { workout in
            let userParticipant = workout.participants.first { $0.userId == user.id }
            let isRoleMatch = userParticipant?.role.userRole == user.role
            let isDateInInterval = interval.contains(workout.startDate ?? Date())
            return isRoleMatch && isDateInInterval
        }
        return filteredWorkouts
    }
    
    private func workoutsToItems(_ workouts: [FTWorkout], completion: @escaping ([WorkoutTimelineItem]) -> Void) {
        ftManager.user.getClients(completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let clients):
                let items = workouts.map { self.workoutToItem($0, clients: clients) }
                completion(items)
                
            case .failure(let error):
                print(error.localizedDescription)
                completion([])
            }
        })
    }
    
    private func workoutToItem(_ workout: FTWorkout, clients: [FTUser]) -> WorkoutTimelineItem {
        let clientId = workout.participants.first(where: { $0.role == .client })?.userId ?? ""
        let user = clients.first(where: { $0.id == clientId }) ?? FTUser()
        
        let name = user.lastName + " " + user.firstName
        let color = workout.workoutKind.color
        let column = getWorkoutColumn(workout)
        let start = getStartTime(workout)
        let duration = getDuration(workout)
        
        let item = WorkoutTimelineItem(title: name,
                                       color: color,
                                       column: column,
                                       start: start,
                                       duration: duration)
        return item
    }
    
    private func getWorkoutColumn(_ workout: FTWorkout) -> Int {
        let startDate = workout.startDate ?? Date()
        //арифметика, чтобы из индекса воскрсенья -1 сделать 6
        let weekday = (Calendar.actual.component(.weekday, from: startDate) - 2 + 7) % 7
        return weekday
    }
    
    private func getStartTime(_ workout: FTWorkout) -> TimeInterval {
        let startDate = workout.startDate ?? Date()
        let startDay = Calendar.current.startOfDay(for: startDate)
        let startInterval = startDate.timeIntervalSince(startDay)
        return startInterval
    }
    
    private func getDuration(_ workout: FTWorkout) -> TimeInterval {
        let startDate = workout.startDate ?? Date()
        let endDate = workout.endDate ?? Date()
        let durationInterval = abs(endDate.timeIntervalSince(startDate))
        return durationInterval
    }
}
