

import XCTest
import FTDomainData
@testable import FitnessTogether

final class BaseWorkoutListModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: BaseWorkoutListModel!
    var refDate: Date = Date()
    
    override func setUp() {
        ftManager = MockFTManager()
        model = BaseWorkoutListModel(ftManager: ftManager)
        model.additionalFilter = { [weak self] workout in
            guard let self else { return false }
            var interval = Calendar.current.dateInterval(of: .weekOfYear, for: refDate)!
            let end = interval.end
            interval.start = refDate.addingTimeInterval(-2 * 3600) //сейчас -2 часа, чтобы прошедшие тренировки не отображались
            interval.end = end
            return interval.contains(workout.startDate ?? Date())
        }
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_GetWorkouts_WorkoutOutOfDate_NextWeek() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate.addingTimeInterval(8 * 24 * 60 * 60))
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: FTWorkout?
        model.getNearestWorkouts(completion: { workouts in
            item = workouts.first
        })
        XCTAssertNil(item)
    }
    
    func test_GetItems_WorkoutOutOfDate_ThidWeekYesterday() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate.addingTimeInterval(-1 * 24 * 60 * 60))
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: FTWorkout?
        model.getNearestWorkouts(completion: { workouts in
            item = workouts.first
        })
        XCTAssertNil(item)
    }
    
    func test_GetItems_WokourOutOfDate_NextWeek_ButBeforeToday() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate.addingTimeInterval(6 * 24 * 60 * 60))
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        //берем примерно середину недели
        refDate = Calendar.current.dateInterval(of: .weekOfYear, for: refDate)!.end.addingTimeInterval(-3 * 24 * 60 * 60)
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: FTWorkout?
        model.getNearestWorkouts(completion: { workouts in
            item = workouts.first
        })
        XCTAssertNil(item)
    }
    
    func test_GetItems_CoachHasClientRole() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate)
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .client)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: FTWorkout?
        model.getNearestWorkouts(completion: { workouts in
            item = workouts.first
        })
        
        XCTAssertNil(item)
    }
    
    func test_GetItems_WorkoutSorting() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout1 = FTWorkout(id: "workoutId1", startDate: refDate.addingTimeInterval(100))
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout1.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout1.id, userId: coach.id, role: .coach)
        
        workout1.participants = [workoutPaticipant1, workoutPaticipant2]
        
        var workout2 = workout1
        workout2.startDate = refDate
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout1, workout2]
        
        var items: [FTWorkout] = []
        model.getNearestWorkouts(completion: { workouts in
            items = workouts
        })
        
        XCTAssertEqual(items[0].startDate, workout2.startDate)
        XCTAssertEqual(items[1].startDate, workout1.startDate)
    }
    
    
}
