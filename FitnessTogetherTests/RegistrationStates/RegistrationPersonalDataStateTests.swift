
import XCTest
import FTDomainData
@testable import FitnessTogether

final class RegistrationPersonalDataStateTests: XCTestCase {
    
    var state: RegistrationPersonalDataState!
    
    override func setUp() {
        state = RegistrationPersonalDataState()
        super.setUp()
    }
    
    override func tearDown() {
        state = nil
        super.tearDown()
    }
    
    func test_Applying() {
        var user = FTUser()
        let name = "TestName"
        let surname = "TestSurname"
        
        state.nameTextfield.text = name
        state.surnameTextfield.text = surname
        state.apply(user: &user)
        
        XCTAssertEqual(user.firstName, name)
        XCTAssertEqual(user.lastName, surname)
    }
    
}
