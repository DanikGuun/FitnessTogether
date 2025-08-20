
import UIKit

public protocol WorkoutListViewControllerDelegate {
    func workoutListVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String)
    func workoutListRequestToOpenAddWorkout(_ vc: UIViewController)
    func workoutListRequestToOpenFilter(_ vc: UIViewController, delegate: (any WorkoutFilterViewControllerDelegate)?)
}

public final class WorkoutListViewController: FTViewController {
    
    var model: WorkoutListModel!
    var delegate: (any WorkoutListViewControllerDelegate)?
    
    private var mainTitleLabel = UILabel.headline("Тренировки на неделю")
    private var workoutCollection: WorkoutListView = WorkoutListCollectionView()
    private var disclosureButton: DisclosureButton!
    
    //MARK: - Lifecycle
    public convenience init(model: WorkoutListModel) {
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
        setupViews()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateItems()
    }
    
    
    //MARK: - UI
    private func setupViews() {
        addStackSubview(mainTitleLabel)
        setupTrainsCollectionView()
        setupDisclosureButton()
        setupAddWorkoutButton()
        addSpacing(.fixed(50))
        setupFilterButton()
    }
    
    private func setupTrainsCollectionView() {
        addStackSubview(workoutCollection, height: 1)
        workoutCollection.itemDidPressed = itemDidPressed
    }
    
    private func setupAddWorkoutButton() {
        let button = UIButton.ftFilled(title: "Добавить тренировку")
        addStackSubview(button)
        button.addAction(UIAction(handler: addWorkoutButtonPressed), for: .touchUpInside)
    }
    
    private func setupDisclosureButton() {
        guard let collection = workoutCollection as? DisclosableView else { return }
        disclosureButton = DisclosureButton(viewToDisclosure: collection)
        addStackSubview(disclosureButton, height: DC.Size.smallButtonHeight)
        disclosureButton.backgroundColor = .systemBackground
    }
    
    private func setupFilterButton() {
        let button = UIButton(configuration: .plain())
        mainTitleLabel.addSubview(button)
        mainTitleLabel.isUserInteractionEnabled = true
        button.snp.makeConstraints { $0.top.bottom.trailing.equalToSuperview() }
        
        let image = UIImage(named: "filter")
        button.setImage(image, for: .normal)
        button.tintColor = .label
        button.addAction(UIAction(handler: filterButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Actions
    private func addWorkoutButtonPressed(_ action: UIAction) {
        updateItems()
        delegate?.workoutListRequestToOpenAddWorkout(self)
    }
    
    private func itemDidPressed(_ item: WorkoutItem) {
        guard let id = item.id else { return }
        delegate?.workoutListVC(self, requestToOpenWorkoutWithId: id)
    }
    
    private func filterButtonPressed(_ action: UIAction) {
        delegate?.workoutListRequestToOpenFilter(self, delegate: nil)
    }
    
    //MARK: - Data
    private func updateItems() {
        model.getItems { [weak self] items in
            guard let self else { return }
            
            workoutCollection.items = items
            disclosureButton.updateViewHeight()
            
            let disclosureButtonHidden = items.count <= 4
            disclosureButton.isHidden = disclosureButtonHidden
        }
    }

}

public extension WorkoutListViewControllerDelegate {
    func workoutListVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String) {}
    func workoutListRequestToOpenAddWorkout(_ vc: UIViewController) {}
    func workoutListRequestToOpenFilter(_ vc: UIViewController, delegate: (any WorkoutFilterViewControllerDelegate)?) {}
}
