
import UIKit
import FTDomainData

public final class WorkoutBuilderViewController: FTViewController {
    var model: WorkoutBuilderModel!
    var delegate: (any WorkoutBuilderViewControllerDelegate)?
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    
    var workoutKindLabel = UILabel()
    var workoutKindSelecter = WorkoutKindSelector()
    
    var descriptionLabel = UILabel()
    var descriptionTextView = AutoSizeTextView()
    
    var dateTimeView = DateTimeView()
    
    var selectClientLabel = UILabel()
    var clientSelecter = ClientListCollectionView()
    var clientDisclosureButton: DisclosureButton!
    
    lazy var nextButton = UIButton.ftFilled(title: model.addButtonTitle)
    
    //MARK: - Lifecycle
    public convenience init(model: WorkoutBuilderModel) {
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
        scrollView.keyboardDismissMode = .onDrag
        setup()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    //MARK: - UI
    
    private func setup() {
        setupTitle(titleLabel, text: model.mainTitle)
        setupSubtitle()
        addSpacing(.fixed(20))
        
        setupTitle(workoutKindLabel, text: "Тип")
        setupWorkoutKindSelecter()
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupTitle(descriptionLabel, text: "Описание")
        setupDescriptionTextView()
        addStackSubview(UIView.underlineView(), height: 2)
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupDateTimeView()
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupTitle(selectClientLabel, text: "Выберите ученика")
        setupClientSelecter()
        setupClientDisclosureButton()
        addSpacing(.fixed(DC.Layout.spacing))
        
        setupNextButton()
        
        setupInitialData()
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
    
    private func setupWorkoutKindSelecter() {
        workoutKindSelecter.constraintHeight(28)
        workoutKindSelecter.selectedWorkoutKind = FTWorkoutKind.allCases.first ?? .none
        addStackSubview(workoutKindSelecter)
    }
    
    private func setupDescriptionTextView() {
        descriptionTextView.font = DC.Font.roboto(weight: .regular, size: 14)
        descriptionTextView.isEditable = true
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.contentInset = .zero
        addStackSubview(descriptionTextView, spaceAfter: .fixed(0))
    }
    
    private func setupDateTimeView() {
        dateTimeView.dateHasChanged = { [weak self] _ in self?.checkNextButtonAvailable() }
        addStackSubview(dateTimeView)
    }
    
    private func setupClientSelecter() {
        addStackSubview(clientSelecter)
    }
    
    private func setupClientDisclosureButton() {
        clientDisclosureButton = DisclosureButton(viewToDisclosure: clientSelecter)
        clientDisclosureButton.backgroundColor = .systemBackground
        clientSelecter.clientDidSelected = { [weak self] _ in self?.checkNextButtonAvailable() }
        addStackSubview(clientDisclosureButton)
        setClientItems()
    }
    
    private func setupNextButton() {
        nextButton.isEnabled = false
        nextButton.addAction(UIAction(handler: nextButtonPressed), for: .touchUpInside)
        addStackSubview(nextButton)
    }
    
    private func setClientItems() {
        model.getClients(completion: { [weak self] clients in
            guard let self else { return }
            
            let items = clients.map { ClientListItem(id: $0.id, title: self.getUserTitle($0), image: UIImage(systemName: "person.circle")) }
            clientSelecter.items = items
            clientDisclosureButton.updateViewHeight()
        })
        
    }
    
    private func getUserTitle(_ user: FTUser) -> String {
        let name = user.firstName
        let lastName = user.lastName.last ?? Character(" ")
        return "\(name) \(lastName)"
    }
    
    private func setupInitialData() {
        model.getInitialWorkoutData(completion: { [weak self] data in
            guard let self, let data else { return }
            let formatter = ISO8601DateFormatter()
            workoutKindSelecter.selectedWorkoutKind = data.workoutKind
            descriptionTextView.text = data.description
            dateTimeView.date = formatter.date(from: data.startDate)
            clientSelecter.selectClient(id: data.userId)
        })
    }
    
    //MARK: - Action
    private func nextButtonPressed(_ action: UIAction?) {
        nextButton.setBusy(true)
        model.saveWorkout(workout: getWorkoutData(), completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(let workout):
                nextButton.setBusy(false)
                delegate?.workoutBuilderVCDidFinish(self, withId: workout.id)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
        
    }
    
    private func getWorkoutData() -> FTWorkoutCreate {
        let kind = workoutKindSelecter.selectedWorkoutKind
        let description = descriptionTextView.text ?? ""
        let date = dateTimeView.date!
        let clientId = clientSelecter.selectedItem!.id
        let data = FTWorkoutCreate(description: description, startDate: date, userId: clientId, workoutKind: kind)
        return data
    }
    
    //MARK: - Validation
    private func checkNextButtonAvailable() {
        let available = dateTimeView.date != nil && clientSelecter.selectedItem != nil
        nextButton.isEnabled = available
    }

}

public protocol WorkoutBuilderViewControllerDelegate {
    func workoutBuilderVCDidFinish(_ vc: UIViewController, withId workoutId: String)
}

public extension WorkoutBuilderViewControllerDelegate {
    func workoutBuilderVCDidFinish(_ vc: UIViewController) {}
}
