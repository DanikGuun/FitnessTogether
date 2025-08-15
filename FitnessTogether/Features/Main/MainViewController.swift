
import UIKit

public final class MainWorkoutsViewController: FTViewController {
    
    var model: MainModel!
    
    private var trainsCollection: MainWorkoutView = MainWorkoutCollectionView()
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
    
    //MARK: - UI
    private func setupViews() {
        addStackSubview(UILabel.headline("Тренировки на неделю"))
        setupTrainsCollectionView()
        setupDisclosureButton()
        setupAddWorkoutButton()
        addSpacing(.fixed(50))
        updateItems()
    }
    
    private func setupTrainsCollectionView() {
        addStackSubview(trainsCollection, height: 1)
    }
    
    private func setupAddWorkoutButton() {
        let button = UIButton.ftFilled(title: "Добавить тренировку")
        addStackSubview(button)
        button.addAction(UIAction(handler: addWorkoutButtonPressed), for: .touchUpInside)
    }
    
    private func addWorkoutButtonPressed(_ action: UIAction) {
        updateItems()
    }
    
    private func setupDisclosureButton() {
        guard let collection = trainsCollection as? DisclosableView else { return }
        disclosureButton = DisclosureButton(viewToDisclosure: collection)
        addStackSubview(disclosureButton, height: DC.Size.smallButtonHeight)
        disclosureButton.backgroundColor = .systemBackground
    }
    

    
    //MARK: - Data
    private func updateItems() {
        model.getItems { [weak self] items in
            guard let self else { return }
            
            trainsCollection.items = items
            disclosureButton.updateViewHeight()
            
            let disclosureButtonHidden = items.count <= 4
            disclosureButton.isHidden = disclosureButtonHidden
        }
    }

}
