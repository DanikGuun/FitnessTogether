
import XCTest
import FTDomainData
@testable import FitnessTogether

final class CoachMainModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: CoachMainModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = CoachMainModel(ftManager: ftManager)
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
        
        var item: WorkoutItem?
        model.getItems(completion: { items in
            item = items.first
        })
        
        XCTAssertEqual(item?.title, client.firstName)
        XCTAssertEqual(item?.date, workout.startDate)
        
    }
    
}
