
import XCTest
import FTDomainData
@testable import FitnessTogether

final class BaseProfileModelTests: XCTestCase {
    
    var ftManager: MockFTManager!
    var model: BaseProfileModel!
    
    var client: FTUser!
    var coach: FTUser!
    
    override func setUp() {
        ftManager = MockFTManager()
        model = BaseProfileModel(ftManager: ftManager)
        super.setUp()
    }
    
    override func tearDown() {
        ftManager = nil
        model = nil
        super.tearDown()
    }
    
    private func setupData() {
        var currentUser = FTUser(firstName: "CurrentUser", id: "CurrentUserId")
        client = FTUser(firstName: "Client", id: "ClientId")
        coach = FTUser(firstName: "Coach", id: "CoachId")
        let clientPair = FTClientCoachPair(clientId: currentUser.id, client: currentUser, coachId: coach.id, coach: coach)
        let coachPair = FTClientCoachPair(clientId: client.id, client: client, coachId: currentUser.id, coach: currentUser)
        currentUser.clients = [coachPair]
        currentUser.coaches = [clientPair]
        
        ftManager._user.user = currentUser
    }
    
    func test_GetClients() {
        setupData()
        
        var fetchedClient: FTUser?
        model.getClients(completion: { clients in
            fetchedClient = clients.first
        })
        
        XCTAssertEqual(fetchedClient, client)
    }
    
    func test_GetCoaches() {
        setupData()
        
        var fetchedCoach: FTUser?
        model.getCoaches(completion: { coaches in
            fetchedCoach = coaches.first
        })
        
        XCTAssertEqual(fetchedCoach, coach)
    }
    
}
