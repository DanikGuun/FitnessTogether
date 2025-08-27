

import XCTest
import FTDomainData
@testable import FitnessTogether

final class CreateWorkoutBuilderModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: CreateWorkoutBuilderModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = CreateWorkoutBuilderModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_SaveWorkout() {
        let workoutCreate = FTWorkoutCreate(description: "Test")
        
        model.saveWorkout(workout: workoutCreate, completion: nil)
        
        let workout = ftManager._workout.workouts.first
        XCTAssertEqual(workout?.description, workoutCreate.description)
        
    }
    
    func test_GetClients() {
        let user = FTUser(firstName: "Test")
        ftManager._user.user?.clients = [FTClientCoachPair(clientId: "client", client: user, coachId: "coach", coach: FTUser())]
        
        var clients: [FTClientData] = []
        model.getClients(completion: { clients = $0 })
        
        XCTAssertEqual(clients.first?.firstName, user.firstName)
    }
    
    func test_GetInitialDataEmpty() {
        var workout: FTWorkoutCreate?
        model.getInitialWorkoutData(completion: { workout = $0 })
        XCTAssertNil(workout)
    }
    
}
