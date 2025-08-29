
import UIKit

public protocol WorkoutViewerViewControllerDelegate {
    func workoutViewerVC(_ vc: WorkoutViewerViewController, requestToShowExerciseWith exerciseId: String, workoutId: String)
}

public final class WorkoutViewerViewController: FTViewController {
    
    var model: WorkoutViewerModel!
    var delegate: (any WorkoutViewerViewControllerDelegate)?
    
    let workoutKindLabel = UILabel.headline("")
    let timeLabel = UILabel.additionalInfo("")
    let descriptionTextView = AutoSizeTextView()
    let exercisesCollectionView = ExerciseCollectionView()
    lazy var exerciseCollectionDisclosureButton = DisclosureButton(viewToDisclosure: exercisesCollectionView)
    let coachLabel = UILabel.subHeadline("Тренер")
    let coachCell = FTUserCellContentView()
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    
    //MARK: - Lifecycle
    
    public convenience init(model: WorkoutViewerModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        setup()
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addStackSubview(workoutKindLabel)
        addStackSubview(timeLabel)
        addStackSubview(descriptionTextView, spaceAfter: .fixed(0))
        addStackSubview(UIView.underlineView())
        setupExerciseCollection()
        addStackSubview(exerciseCollectionDisclosureButton)
        addStackSubview(coachLabel)
        setupCoachCell()
    }
    
    private func setupExerciseCollection() {
        addStackSubview(exercisesCollectionView)
        exercisesCollectionView.itemDidPressed = exerciseItemsDidPressed
    }
    
    private func setupCoachCell() {
        addStackSubview(coachCell)
        coachCell.constraintHeight(65)
    }
    
    private func updateData() {
        updateWorkoutData()
        updateExercises()
        updateCoach()
    }
    
    //MARK: - Data
    private func updateWorkoutData() {
        model.getWorkoutItem(completion: { [weak self] workout in
            self?.workoutKindLabel.text = workout.workoutKind.title
            let formatter = DateFormatter()
            formatter.dateFormat = "cccc, HH:mm"
            formatter.locale = Locale.actual
            self?.timeLabel.text = formatter.string(from: workout.startDate ?? Date())
            self?.descriptionTextView.text = workout.description.isEmpty ? "Описания нет(" : workout.description
        })
    }
    
    private func updateExercises() {
        model.getExercises(completion: { [weak self] exercises in
            self?.exercisesCollectionView.items = exercises
        })
    }
    
    private func updateCoach() {
        model.getCoachName(completion: { [weak self] name in
            self?.coachCell.titleLabel.text = name
        })
    }
    
    //MARK: - Actions
    private func exerciseItemsDidPressed(_ item: ExerciseCollectionItem) {
        delegate?.workoutViewerVC(self, requestToShowExerciseWith: item.id ?? "", workoutId: model.workoutId)
    }
    
}

public extension WorkoutViewerViewControllerDelegate {
    func workoutViewerVC(_ vc: WorkoutViewerViewController, requestToShowExerciseWith exerciseId: String, workoutId: String) {}
}
