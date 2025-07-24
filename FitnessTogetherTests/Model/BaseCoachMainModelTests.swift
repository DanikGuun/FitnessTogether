

import XCTest
import FTDomainData
@testable import FitnessTogether

final class BaseCoachMainModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: BaseCoachMainModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = BaseCoachMainModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    let refDate = Date()
    
    func test_DataToItem() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate)
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: CoachTrainItem?
        model.getItems(completion: { items in
            item = items.first
        })
        
        XCTAssertEqual(item?.name, client.firstName)
        XCTAssertEqual(item?.date, workout.startDate)
        
    }
    
    func test_GetItems_WorkoutOutOfDate_NextWeek() {
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
        
        var item: CoachTrainItem?
        model.getItems(completion: { items in
            item = items.first
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
        
        var item: CoachTrainItem?
        model.getItems(completion: { items in
            item = items.first
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
        
        var item: CoachTrainItem?
        model.getItems(completion: { items in
            item = items.first
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
        
        var items: [CoachTrainItem] = []
        model.getItems(completion: { _items in
            items = _items
        })
        
        XCTAssertEqual(items[0].date, workout2.startDate)
        XCTAssertEqual(items[1].date, workout1.startDate)
    }
    
    
}
