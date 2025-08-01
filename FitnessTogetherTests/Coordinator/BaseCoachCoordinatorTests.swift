
import XCTest
import FTDomainData
@testable import FitnessTogether

final class BaseCoachCoordinatorTests: XCTestCase {
    
    fileprivate var factory: MockCoachVCFactory!
    var coordinator: BaseCoachCoordinator!
    
    override func setUp() {
        factory = MockCoachVCFactory()
        coordinator = BaseCoachCoordinator(factory: factory)
        coordinator.needAnimate = false
        super.setUp()
    }
    
    override func tearDown() {
        factory = nil
        coordinator = nil
        super.tearDown()
    }
    
    func test_GoToAddWorkout() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        XCTAssertEqual(coordinator.currentVC?.title, "AddWorkout")
    }
    
}

fileprivate class MockCoachVCFactory: CoachViewControllerFactory {
    
    func makeTabBarVC(calendarDelegate: (any FitnessTogether.CalendarViewControllerDelegate)?) -> UITabBarController {
        return UITabBarController()
    }
    
    func makeMainVC() -> UIViewController {
        return vc("Main")
    }
    
    func makeCalendarVC(delegate: (any FitnessTogether.CalendarViewControllerDelegate)?) -> UIViewController {
        return vc("Calendar")
    }
    
    func makeWorkoutsVC() -> UIViewController {
        return vc("Workouts")
    }
    
    func makeProfileVC() -> UIViewController {
        return vc("Profile")
    }
    
    func makeAddWorkoutVC(startInterval: DateInterval?) -> UIViewController {
        return vc("AddWorkout")
    }
    
    private func vc(_ title: String) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        return vc
    }
    
    
}
