
import UIKit
import FTDomainData

public protocol ExerciseListViewControllerDelegate {
    func exerciseBuilderVCDidFinish(_ vc: ExerciseListViewController)
    func exerciseBuilderVCrequestToOpenAddExerciseVC(_ vc: ExerciseListViewController, workoutId: String)
    func exerciseBuilderVCrequestToOpenEditExerciseVC(_ vc: ExerciseListViewController, exerciseId: String)
}

public final class ExerciseListViewController: FTViewController {
    var delegate: (any ExerciseListViewControllerDelegate)?
    var model: (any ExerciseListModel)!
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var selectExercisesLabel = UILabel.headline("Добавьте упражнения")
    var exerciseCollectionView = ExerciseCollectionView()
    var disclosureButton: DisclosureButton!

    lazy var addExerciseButton = UIButton.ftPlain(title: "Добавить упражнение", handler: addExerciseButtonPressed)
    lazy var addWorkoutButton = UIButton.ftFilled(title: "Сохранить упражнения", handler: saveExercisesButtonPressed)

    var exercises: [FTExerciseCreate] = []
    
    //MARK: - Lifecycle
    public convenience init(model: ExerciseListModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItems()
    }
    
    //MARK: - UI
    private func setup() {
        setupTitle(titleLabel, text: "Конструктор тренировок")
        setupSubtitle()
        addStackSubview(selectExercisesLabel)
        addStackSubview(exerciseCollectionView)
        setupDisclosureButton()
        addStackSubview(addExerciseButton)
        addStackSubview(addWorkoutButton)
    }

    private func setupTitle(_ label: UILabel, text: String = "") {
        label.font = DC.Font.headline
        label.text = text
        label.textAlignment = .center
        addStackSubview(label)
    }

    private func setupSubtitle() {
        subtitleLabel.font = DC.Font.additionalInfo
        subtitleLabel.textColor = .systemGray3
        subtitleLabel.textAlignment = .center
        subtitleLabel.text = "Соберите тренировку"
        addStackSubview(subtitleLabel)
    }

    private func setupDisclosureButton() {
        disclosureButton = DisclosureButton(viewToDisclosure: exerciseCollectionView)
        disclosureButton.backgroundColor = .systemBackground
        disclosureButton.isHidden = exerciseCollectionView.items.count <= 6
        addStackSubview(disclosureButton)
    }

    private func addExerciseButtonPressed(_ action: UIAction) {
        delegate?.exerciseBuilderVCrequestToOpenAddExerciseVC(self, workoutId: model.workoutId)
    }

    private func saveExercisesButtonPressed(_ action: UIAction) {
        delegate?.exerciseBuilderVCDidFinish(self)
    }

    //MARK: - Exercises
    private func updateItems() {
        model.getExercises(completion: { [weak self] exercises in
            let items = exercises.map { ExerciseCollectionItem(title: $0.name, subtitle: $0.description, image: nil) }
            self?.exerciseCollectionView.items = items
        })
    }

    
}

public extension ExerciseListViewControllerDelegate {
    func exerciseBuilderVCDidFinish(_ vc: ExerciseListViewController) {}
    func exerciseBuilderVCrequestToOpenAddExerciseVC(_ vc: ExerciseListViewController, workoutId: String) {}
    func exerciseBuilderVCrequestToOpenEditExerciseVC(_ vc: ExerciseListViewController, exerciseId: String) {}
}
