
import UIKit

public protocol MainViewControllerDelegate {
    func mainVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String)
    func mainVCRequestToOpenAddWorkout(_ vc: UIViewController)
}

public final class MainWorkoutsViewController: FTViewController {
    
    var model: MainModel!
    var delegate: (any MainViewControllerDelegate)?
    
    private var workoutCollection: MainWorkoutView = MainWorkoutCollectionView()
    private var disclosureButton: DisclosureButton!
    
    //MARK: - Lifecycle
    public convenience init(model: MainModel) {
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
        addStackSubview(UILabel.headline("Тренировки на неделю"))
        setupTrainsCollectionView()
        setupDisclosureButton()
        setupAddWorkoutButton()
        addSpacing(.fixed(50))
    }
    
    private func setupTrainsCollectionView() {
        addStackSubview(workoutCollection, height: 1)
        workoutCollection.itemDidPressed = itemDidPressed
    }
    
    private func itemDidPressed(_ item: WorkoutItem) {
        guard let id = item.id else { return }
        delegate?.mainVC(self, requestToOpenWorkoutWithId: id)
    }
    
    private func setupAddWorkoutButton() {
        let button = UIButton.ftFilled(title: "Добавить тренировку")
        addStackSubview(button)
        button.addAction(UIAction(handler: addWorkoutButtonPressed), for: .touchUpInside)
    }
    
    private func addWorkoutButtonPressed(_ action: UIAction) {
        updateItems()
        delegate?.mainVCRequestToOpenAddWorkout(self)
        
    }
    
    private func setupDisclosureButton() {
        guard let collection = workoutCollection as? DisclosableView else { return }
        disclosureButton = DisclosureButton(viewToDisclosure: collection)
        addStackSubview(disclosureButton, height: DC.Size.smallButtonHeight)
        disclosureButton.backgroundColor = .systemBackground
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

public extension MainViewControllerDelegate {
    func mainVC(_ vc: UIViewController, requestToOpenWorkoutWithId workoutId: String) {}
    func mainVCRequestToOpenAddWorkout(_ vc: UIViewController) {}
}
