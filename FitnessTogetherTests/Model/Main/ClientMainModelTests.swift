

import XCTest
import FTDomainData
@testable import FitnessTogether

final class ClientMainModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: ClientMainModel!
    
    let refDate = Date()
    
    override func setUp() {
        ftManager = MockFTManager()
        model = ClientMainModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_Data_ToItems() {
        let client = FTUser(firstName: "Client", role: .client, id: "ClientId")
        var coach = FTUser(firstName: "Coach", role: .coach, id: "CoachId")
        
        let pair = FTClientCoachPair(clientId: client.id, client: client, coachId: coach.id, coach: coach)
        coach.clients = [pair]
        
        var workout = FTWorkout(id: "workoutId", startDate: refDate, workoutKind: .force)
        
        let workoutPaticipant1 = FTWorkoutParticipant(workoutId: workout.id, userId: client.id, role: .client)
        let workoutPaticipant2 = FTWorkoutParticipant(workoutId: workout.id, userId: coach.id, role: .coach)
        
        workout.participants = [workoutPaticipant1, workoutPaticipant2]
        
        ftManager._user.user = client
        ftManager._workout.workouts = [workout]
        
        var item: WorkoutItem?
        model.getItems(completion: { items in
            item = items.first
        })
        
        XCTAssertEqual(item?.title, FTWorkoutKind.force.title)
        XCTAssertEqual(item?.date, workout.startDate)
    }
    
}
