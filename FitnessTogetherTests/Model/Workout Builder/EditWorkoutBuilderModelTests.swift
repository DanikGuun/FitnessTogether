

import XCTest
import FTDomainData
@testable import FitnessTogether

final class EditWorkoutBuilderModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: EditWorkoutBuilderModel!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = EditWorkoutBuilderModel(ftManager: ftManager, workoutId: "Test")
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    func test_SaveWorkout() {
        let workoutCreate = FTWorkout(id: "Test", description: "top")
        ftManager._workout.workouts = [workoutCreate]
        let newData = FTWorkoutCreate(description: "ne top")
        
        model.saveWorkout(workout: newData, completion: nil)
        
        let workout = ftManager._workout.workouts.first
        XCTAssertEqual(workout?.description, newData.description)
        
    }
    
    func test_GetClients() {
        let user = FTUser(firstName: "Test")
        ftManager._user.user?.clients = [FTClientCoachPair(clientId: "client", client: user, coachId: "coach", coach: FTUser())]
        
        var clients: [FTClientData] = []
        model.getClients(completion: { clients = $0 })
        
        XCTAssertEqual(clients.first?.firstName, user.firstName)
    }
    
    func test_GetInitialData() {
        let workout = FTWorkout(id: "Test", description: "top description")
        ftManager._workout.workouts = [workout]
        
        var data: FTWorkoutCreate?
        model.getInitialWorkoutData(completion: { data = $0 })
        
        XCTAssertEqual(data?.description, workout.description)
    }
    
}
