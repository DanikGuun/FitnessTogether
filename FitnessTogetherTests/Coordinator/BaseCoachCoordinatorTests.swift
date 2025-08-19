
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
    
    func test_GoToEditWorkout_FromMain() {
        coordinator.mainVC(UIViewController(), requestToOpenWorkoutWithId: "id")
        XCTAssertEqual(coordinator.currentVC?.title, "EditWorkout")
    }
    
    func test_GoToEditWorkout_FromCalendar() {
        coordinator.calendarViewControllerGoToEditWorkout(UIViewController(), workoutId: "")
        XCTAssertEqual(coordinator.currentVC?.title, "EditWorkout")
    }
    
}

fileprivate class MockCoachVCFactory: CoachViewControllerFactory {
    
    
    func makeTabBarVC(mainDeleage: (any MainViewControllerDelegate)?, calendarDelegate: (any FitnessTogether.CalendarViewControllerDelegate)?) -> UITabBarController {
        return UITabBarController()
    }
    
    func makeMainVC(delegate: (any MainViewControllerDelegate)?) -> UIViewController {
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
    
    func makeAddWorkoutVC(startInterval: DateInterval?, delegate: (any WorkoutBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("AddWorkout")
    }
    
    func makeEditWorkoutVC(workoutId: String, delegate: (any FitnessTogether.WorkoutBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("EditWorkout")
    }
    
    func makeCreateExerciseVC(delegate: (any ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("CreateExercise")
    }
    
    func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any FitnessTogether.ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("EditExercise")
    }
    
    func changeWorkoutBuilderToEditModel(_ vc: UIViewController, workoutId: String) {
        
    }
    
    func makeExerciseListVC(workoutId: String, delegate: (any FitnessTogether.ExerciseListViewControllerDelegate)?) -> UIViewController {
        return vc("ExerciseList")
    }
    
    func makeCreateExerciseVC(workoutId: String, delegate: (any FitnessTogether.ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("ExerciseCreate")
    }
    
    private func vc(_ title: String) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        return vc
    }
    
    
}
