
import UIKit
import FTDomainData

public protocol WorkoutListViewControllerDelegate {
    func workoutListVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String)
    func workoutListRequestToOpenAddWorkout(_ vc: UIViewController)
    func workoutListRequestToOpenFilter(_ vc: UIViewController, delegate: (any WorkoutFilterViewControllerDelegate)?)
}

public final class WorkoutListViewController: FTViewController, WorkoutFilterViewControllerDelegate {
    
    var model: WorkoutListModel!
    var delegate: (any WorkoutListViewControllerDelegate)?
    
    var mainTitleLabel = UILabel.headline("Тренировки на неделю")
    var filterButton = UIButton(configuration: .plain())
    var workoutCollection: WorkoutListView = WorkoutListCollectionView()
    var disclosureButton: DisclosureButton!
    let addWorkoutButton = UIButton.ftFilled(title: "Добавить тренировку")
    let analyziseMyProgressButton = UIButton.ftPlain(title: "Проанализировать мой прогресс")
    
    
    //MARK: - Lifecycle
    public convenience init(model: WorkoutListModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        setupViews()
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
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
        setupAnalyziseMyProgressView()
    }
    
    private func setupTrainsCollectionView() {
        addStackSubview(workoutCollection, height: 1)
        workoutCollection.itemDidPressed = itemDidPressed
    }
    
    private func setupAddWorkoutButton() {
        addStackSubview(addWorkoutButton)
        addWorkoutButton.addAction(UIAction(handler: addWorkoutButtonPressed), for: .touchUpInside)
    }
    
    private func setupDisclosureButton() {
        guard let collection = workoutCollection as? DisclosableView else { return }
        disclosureButton = DisclosureButton(viewToDisclosure: collection)
        addStackSubview(disclosureButton, height: DC.Size.smallButtonHeight)
        disclosureButton.backgroundColor = .systemBackground
    }
    
    private func setupFilterButton() {
        mainTitleLabel.addSubview(filterButton)
        mainTitleLabel.isUserInteractionEnabled = true
        filterButton.snp.makeConstraints { $0.top.bottom.trailing.equalToSuperview() }
        
        let image = UIImage(named: "Filter")
        filterButton.setImage(image, for: .normal)
        filterButton.tintColor = .label
        filterButton.addAction(UIAction(handler: filterButtonPressed), for: .touchUpInside)
    }
    
    private func setupAnalyziseMyProgressView() {
        addStackSubview(analyziseMyProgressButton)
        analyziseMyProgressButton.addAction(UIAction(handler: analyziseMyProgressButton), for: .touchUpInside)
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
        delegate?.workoutListRequestToOpenFilter(self, delegate: self)
    }
    
    private func analyziseMyProgressButton(_ action: UIAction?) {
        model.analyziseMyProgress { result in
            if result {
                self.tabBarController?.selectedIndex = 2
            }
        }
    }
    
    //MARK: - Workout Filter\
    public func workoutFilterVCGetDefaultBag(_ vc: UIViewController) -> FTFilterBag {
        return model.initialFilterBag
    }
    
    public func workoutFilterVCGetInitialBag(_ vc: UIViewController) -> FTFilterBag {
        return model.currentFilterBag
    }
    
    public func workoutFilter(_ vc: UIViewController, getWorkoutsCountFor filterBag: FTFilterBag, completion: @escaping (Int) -> Void) {
        model.getItems(withFilter: filterBag, completion: { items in
            completion(items.count)
        })
    }
    
    public func workoutFilterVC(_ vc: UIViewController, didSelect filterBag: FTFilterBag) {
        model.currentFilterBag = filterBag
        updateItems()
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
