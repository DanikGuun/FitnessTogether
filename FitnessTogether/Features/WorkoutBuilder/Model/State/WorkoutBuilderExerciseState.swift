
import UIKit
import FTDomainData

public final class WorkoutBuilderExerciseState: WorkoutBuilderState, ExerciseCreateViewControllerDelegate {
    
    public var delegate: (any ScreenStateDelegate)?
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var selectExercisesLabel = UILabel.headline("Добавьте упражнения")
    var exerciseCollectionView = ExerciseCollectionView()
    var disclosureButton: DisclosureButton!
    
    lazy var addExerciseButton = UIButton.ftPlain(title: "Добавить упражнение", handler: addExerciseButtonPressed)
    lazy var addWorkoutButton = UIButton.ftFilled(title: "Добавить тренировку", handler: addWorkoutButtonPressed)
    
    var exercises: [FTExerciseCreate] = [] { didSet { itemHasUpdated()} }
    
    init() {
        setup()
    }
    
    public func apply(workoutCreate workout: inout FTWorkoutCreate, exercises: inout [FTExerciseCreate]) {
        exercises = self.exercises
    }
    
    public func viewsToPresent() -> [UIView] {
        return [titleLabel, subtitleLabel, selectExercisesLabel, exerciseCollectionView, disclosureButton, addExerciseButton, addWorkoutButton]
    }
    
    //MARK: - UI
    private func setup() {
        setupTitle(titleLabel, text: "Конструктор тренировок")
        setupSubtitle()
        setupDisclosureButton()
    }
    
    private func setupTitle(_ label: UILabel, text: String = "") {
        label.font = DC.Font.headline
        label.text = text
        label.textAlignment = .center
    }
    
    private func setupSubtitle() {
        subtitleLabel.font = DC.Font.additionalInfo
        subtitleLabel.textColor = .systemGray3
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Соберите тренировку"
    }
    
    private func setupDisclosureButton() {
        disclosureButton = DisclosureButton(viewToDisclosure: exerciseCollectionView)
        disclosureButton.backgroundColor = .systemBackground
        disclosureButton.isHidden = exerciseCollectionView.items.count <= 6
    }
    
    private func addExerciseButtonPressed(_ action: UIAction) {
        (delegate as? WorkoutBuilderStateDelegate)?.workoutBuilderStateRequestToAddExercise(self)
    }
    
    private func addWorkoutButtonPressed(_ action: UIAction) {
        delegate?.screenStateGoNext(self)
    }
    
    //MARK: - Exercises
    private func itemHasUpdated() {
        var items = exercises.map { ExerciseCollectionItem(title: $0.name, subtitle: $0.description, image: nil) }
        exerciseCollectionView.items = items
    }
    
    //MARK: - Exercises Delegate
    public func exerciseVC(_ vc: ExerciseCreateViewController, requestToCreate exercise: FTExerciseCreate) {
        exercises.append(exercise)
        exerciseCollectionView.items = exercises.map { ExerciseCollectionItem(title: $0.name, subtitle: $0.description, image: UIImage(systemName: "trophy.circle")) }
    }
    
}
