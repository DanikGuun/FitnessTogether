
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
        coordinator.tabBarVC.selectedIndex = 1
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
        coordinator.workoutListVC(UIViewController(), requestToOpenWorkoutWithId: "id")
        XCTAssertEqual(coordinator.currentVC?.title, "EditWorkout")
    }
    
    func test_GoToEditWorkout_FromCalendar() {
        coordinator.calendarViewControllerGoToEditWorkout(UIViewController(), workoutId: "")
        XCTAssertEqual(coordinator.currentVC?.title, "EditWorkout")
    }
    
    func test_WorkoutBuilder_DidFinish_Model_To_Edit() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        coordinator.workoutBuilderVCDidFinish(UIViewController(), withId: "")
        XCTAssertTrue(factory.wasChangeWorkoutBuilderToEditCalled)
    }

    func test_WorkoutBuilder_DidFinish_GoToExetcisesList() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        coordinator.workoutBuilderVCDidFinish(UIViewController(), withId: "")
        XCTAssertEqual(coordinator.currentVC?.title, "ExerciseList")
    }
    
    func test_ExerciseList_DidFinish_Pop() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        coordinator.workoutBuilderVCDidFinish(UIViewController(), withId: "")
        coordinator.exerciseListVCDidFinish(UIViewController())
        
        XCTAssertEqual(coordinator.currentVC?.title, "Calendar")
    }
    
    func test_ExerciseList_GoToAddExercise() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        coordinator.workoutBuilderVCDidFinish(UIViewController(), withId: "")
        coordinator.exerciseListVCrequestToOpenAddExerciseVC(UIViewController(), workoutId: "")
        
        XCTAssertEqual(coordinator.currentVC?.title, "ExerciseCreate")
    }
    
    func test_ExerciseList_GoToEditExercise() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        coordinator.workoutBuilderVCDidFinish(UIViewController(), withId: "")
        coordinator.exerciseListVCrequestToOpenEditExerciseVC(UIViewController(), workoutId: "", exerciseId: "")
        
        XCTAssertEqual(coordinator.currentVC?.title, "ExerciseEdit")
    }
    
    func test_ExerciseBuilderDidFinish_Pop() {
        coordinator.calendarViewControllerGoToAddWorkout(UIViewController(), interval: nil)
        coordinator.workoutBuilderVCDidFinish(UIViewController(), withId: "")
        coordinator.exerciseListVCrequestToOpenEditExerciseVC(UIViewController(), workoutId: "", exerciseId: "")
        coordinator.exerciseBuilderVCDidFinish(UIViewController())
        
        XCTAssertEqual(coordinator.currentVC?.title, "ExerciseList")
    }
    
}

fileprivate class MockCoachVCFactory: CoachViewControllerFactory {
    var wasChangeWorkoutBuilderToEditCalled = false
    
    func makeTabBarVC(workoutListDeleage: (any WorkoutListViewControllerDelegate)?, calendarDelegate: (any FitnessTogether.CalendarViewControllerDelegate)?) -> UITabBarController {
        let vcs = [makeMainVC(delegate: nil), makeCalendarVC(delegate: nil), makeProfileVC()]
        let controller = UITabBarController()
        controller.viewControllers = vcs
        return controller
    }
    
    func makeMainVC(delegate: (any WorkoutListViewControllerDelegate)?) -> UIViewController {
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
    
    func makeExerciseListVC(workoutId: String, delegate: (any FitnessTogether.ExerciseListViewControllerDelegate)?) -> UIViewController {
        return vc("ExerciseList")
    }
    
    func makeCreateExerciseVC(workoutId: String, delegate: (any FitnessTogether.ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("ExerciseCreate")
    }

    func makeEditExerciseVC(workoutId: String, exerciseId: String, delegate: (any FitnessTogether.ExerciseBuilderViewControllerDelegate)?) -> UIViewController {
        return vc("ExerciseEdit")
    }
    
    func changeWorkoutBuilderToEditModel(_ vc: UIViewController, workoutId: String) {
        wasChangeWorkoutBuilderToEditCalled = true
    }
    
    
    private func vc(_ title: String) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        return vc
    }
    
    
}
