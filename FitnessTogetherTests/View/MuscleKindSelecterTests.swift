

import XCTest
import FTDomainData
@testable import FitnessTogether

final class MuscleKindSelecterTests: XCTestCase {
    
    var selecter: MuscleKindSelecter!
    
    override func setUp() {
        selecter = MuscleKindSelecter()
        super.setUp()
    }
    
    override func tearDown() {
        selecter = nil
        super.tearDown()
    }
    
    func test_SelectedKinds() {
        let button = selecter.buttons.randomElement()!
        let title = button.configuration?.title
        
        button.isSelected = true
        let kindTitle = selecter.selectedMuscleKinds.first!.title
        
        XCTAssertEqual(title, kindTitle)
    }
    
    func test_SetSelectedKinds() {
        let kinds: [FTMuscleKind] = [.calves, .back]
        
        selecter.select(kinds)
        let selectedTitles = selecter.selectedMuscleKinds.map { $0.title }
        
        for kind in kinds {
            let title = kind.title
            XCTAssertTrue(selectedTitles.contains(title))
        }
    }
    
}
