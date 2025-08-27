
import UIKit
import OutlineTextField
import FTDomainData

public protocol ExerciseBuilderViewControllerDelegate {
    func exerciseBuilderVCDidFinish(_ vc: UIViewController)
    func exerciseBuilderVCGoToSetList(_ vc: UIViewController, exerciseId: String)
}

public final class ExerciseBuilderViewController: FTViewController, UITextFieldDelegate {
    
    public var delegate: (any ExerciseBuilderViewControllerDelegate)?
    var model: (any ExerciseBuilderModel)!
    
    public override var title: String? { get { mainTitle.text } set { mainTitle.text = newValue } }
    var complexity: Int {
        get { Int(complexitySlider.fill * 10) }
        set {
            complexitySlider.fill = Double(newValue) / 10
            complexityUpdated(nil)
        }
    }
    
    var mainTitle = UILabel()
    var nameTitle = UILabel()
    var nameTextField = OutlinedTextField.ftTextField(placeholder: "Название")
    var descriptionTitle = UILabel()
    var descriptionTextView = AutoSizeTextView()
    var muscleKindTitle = UILabel()
    var muscleKindSelecter = MuscleKindSelecter()
    var complexityTitle = UILabel()
    var complexitySlider = ComplexitySlider()
    lazy var goToSetButton = UIButton.ftPlain(title: "Добавить подходы", handler: goToSetListButtonPressed)
    lazy var addExerciseButton = UIButton.ftFilled(title: model.addButtonTitle, handler: addExerciseButtonPressed)
    
    //MARK: - Lifecycle
    public convenience init(model: (any ExerciseBuilderModel)) {
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
        setup()
        setupInitialData()
    }
    
    private func setup() {
        setupMainTitle()
        addSpacing(.fixed(25))
        setupTitle(nameTitle, title: "Название")
        setupNameTextField()
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupTitle(descriptionTitle, title: "Описание")
        setupDescriptionTextView()
        addStackSubview(UIView.underlineView(.systemGray4))
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupTitle(muscleKindTitle, title: "Группы мышц")
        setupMuscleKindSelecter()
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupTitle(complexityTitle, title: "Сложность: 0")
        setupComplexitySlider()
        addSpacing(.fixed(50))
        
        addStackSubview(goToSetButton)
        addStackSubview(addExerciseButton)
    }
    
    private func setupMainTitle() {
        addStackSubview(mainTitle)
        mainTitle.font = DC.Font.headline
        mainTitle.textAlignment = .center
    }
    
    private func setupTitle(_ label: UILabel, title text: String) {
        label.font = DC.Font.headline
        label.text = text
        addStackSubview(label)
    }
    
    private func setupNameTextField() {
        addStackSubview(nameTextField)
        nameTextField.delegate = self
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = DC.Font.additionalInfo
        descriptionTextView.textColor = .systemGray
        addStackSubview(descriptionTextView, spaceAfter: .fixed(0))
    }
    
    private func setupMuscleKindSelecter() {
        addStackSubview(muscleKindSelecter)
        muscleKindSelecter.addAction(UIAction(handler: { [weak self] _ in
            self?.view.endEditing(true)
        }), for: .valueChanged)
    }
    
    private func setupComplexitySlider() {
        addStackSubview(complexitySlider)
        complexitySlider.addAction(UIAction(handler: complexityUpdated), for: .valueChanged)
    }
    
    private func setupInitialData() {
        model.getInitialExerciseData(completion: { [weak self] exercise in
            guard let self else { return }
            nameTextField.text = exercise.name
            descriptionTextView.text = exercise.description
            muscleKindSelecter.selectedMuscleKinds = exercise.muscleKinds
            complexity = exercise.complexity
        })
    }
    
    //MARK: - Actions
    private func complexityUpdated(_ action: UIAction?) {
        let value = Int(complexitySlider.fill * 10)
        complexityTitle.text = "Сложность: \(value)"
        view.endEditing(true)
    }
    
    private func goToSetListButtonPressed(_ action: UIAction?) {
        model.saveExercise(getExerciseData(), completion: { [weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                delegate?.exerciseBuilderVCGoToSetList(self, exerciseId: model.exerciseId!)
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func addExerciseButtonPressed(_ action: UIAction?) {
        let data = getExerciseData()
        model.saveExercise(data, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(_):
                delegate?.exerciseBuilderVCDidFinish(self)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func getExerciseData() -> FTExerciseCreate {
        let name = nameTextField.text ?? ""
        let description = descriptionTextView.text ?? ""
        let complexity = complexity
        let muscleKinds = muscleKindSelecter.selectedMuscleKinds
        return FTExerciseCreate(name: name, description: description, muscleKinds: muscleKinds, complexity: complexity)
    }
    
}

public extension ExerciseBuilderViewControllerDelegate {
    func exerciseBuilderVCDidFinish(_ vc: UIViewController) {}
    func exerciseBuilderVCGoToSetList(_ vc: UIViewController, exerciseId: String) {}
}
