

import XCTest
import FTDomainData
@testable import FitnessTogether

final class CoachCalendarModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: CoachCalendarModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = CoachCalendarModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_GetInterval() {
        let startDate = Date()
        let endDate = Date().addingTimeInterval(60*60)
        let expectedInterval = DateInterval(start: startDate, end: endDate)
        
        let interval = model.getTrainInterval(startDate: startDate)
        
        XCTAssertEqual(interval, expectedInterval)
    }
    
    let refDate = Date()
    let interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
    
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
        
        var item: WorkoutTimelineItem?
        model.getItems(for: interval, completion: { items in
            item = items.first
        })
        XCTAssertNil(item)
    }
    
    func test_GetItems_WorkoutOutOfDate_LastWeek() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate.addingTimeInterval(-8 * 24 * 60 * 60))
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: WorkoutTimelineItem?
        model.getItems(for: interval, completion: { items in
            item = items.first
        })
        XCTAssertNil(item)
    }
    
    func test_GetItems_CoachHasClientRole() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", lastName: "last", role: .coach, id: "CoachId")
        
        let pair1 = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        let pair2 = FTClientCoachPair(clientId: coach.id, client: coach, coachId: coach.id, coach: coach)
        coach.clients = [pair1, pair2]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate)
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .client)
        
        workout.participants = [workoutPaticipant2, workoutPaticipant1]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: WorkoutTimelineItem?
        model.getItems(for: interval, completion: { items in
            item = items.first
        })
        
        XCTAssertEqual(item?.title, coach.lastName + " " + coach.firstName)
    }
    
    func test_GetItems_Correct() {
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
        
        var item: WorkoutTimelineItem?
        model.getItems(for: interval, completion: { items in
            item = items.first
        })
        
        XCTAssertNotNil(item)
    }
    
    func test_GetItems_Correct_NextWeek() {
        let refDate = refDate.addingTimeInterval(9 * 24 * 60 * 60)
        let interval = Calendar.current.dateInterval(of: .weekOfYear, for: refDate)!
        
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
        
        var item: WorkoutTimelineItem?
        model.getItems(for: interval, completion: { items in
            item = items.first
        })
        
        XCTAssertNotNil(item)
    }
    
    func test_GetItems_Convert_ToItem() {
        let client = FTUser(firstName: "Client", lastName: "Zhop", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workout", startDate: refDate, endDate: refDate.addingTimeInterval(200), workoutKind: .force)
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = coach
        ftManager._workout.workouts = [workout]
        
        var item: WorkoutTimelineItem?
        model.getItems(for: interval, completion: { items in
            item = items.first
        })
        
        let startDay = Calendar.current.startOfDay(for: refDate)
        let expectedTitle = "\(client.lastName) \(client.firstName)"
        let expectedColor = workout.workoutKind.color
        let expectedColumn = (Calendar.actual.component(.weekday, from: refDate) - 2 + 7) % 7
        let expectedStart = workout.startDate!.timeIntervalSince(startDay)
        let expectedDuration = workout.duration
        
        XCTAssertEqual(item?.title, expectedTitle)
        XCTAssertEqual(item?.color, expectedColor)
        XCTAssertEqual(item?.column, expectedColumn)
        XCTAssertEqual(item?.start, expectedStart)
        XCTAssertEqual(item?.duration, expectedDuration)
        
        XCTAssertTrue(item!.start > 0.cgf)
        XCTAssertTrue(item!.start < 86400.cgf)
    }
    
}
