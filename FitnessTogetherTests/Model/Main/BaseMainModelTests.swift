

import XCTest
import FTDomainData
@testable import FitnessTogether

final class BaseMainModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: BaseMainModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = BaseMainModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    let refDate = Date()
    
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
        model.refDate = Calendar.current.dateInterval(of: .weekOfYear, for: refDate)!.end.addingTimeInterval(-3 * 24 * 60 * 60)
        
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
