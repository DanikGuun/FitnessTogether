
import UIKit

public final class CoachMainViewController: FTViewController {
    
    var model: MainModel!
    
    private var trainsCollection: CoachTrainsView = CoachTrainsCollectionView()
    private var disclosureButton = UIButton(configuration: .plain())
    private var disclosureImageView: UIImageView = UIImageView()
    
    private let trainCollectionMaxHeight: CGFloat = 270
    
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
        setTrainCollectionDisclosed(false)
    }
    
    private func setTrainCollectionDisclosed(_ isDisclosed: Bool) {
        view.layoutIfNeeded()
        var height: CGFloat = 0
        if isDisclosed {
            height = trainsCollection.contentSize.height
        }
        else {
            height = min(trainCollectionMaxHeight, trainsCollection.contentSize.height)
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.trainsCollection.constraintHeight(max(height, 1))
            self?.view.layoutIfNeeded()
        })
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
        addStackSubview(disclosureButton)
        disclosureButton.changesSelectionAsPrimaryAction = true
        disclosureButton.addAction(UIAction(handler: disclosureButtonPressed), for: .touchUpInside)
        disclosureButton.configurationUpdateHandler = disclosureButtonConfigurationHandler
        
        let imageConf = UIImage.SymbolConfiguration(weight: .medium)
        let image = UIImage(systemName: "chevron.down")?.withConfiguration(imageConf)
        disclosureImageView.image = image
        disclosureImageView.contentMode = .scaleAspectFit
        disclosureImageView.tintColor = .ftOrange
        disclosureButton.addSubview(disclosureImageView)
        disclosureImageView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.bottom.trailing.equalToSuperview().inset(8)
            maker.width.equalTo(disclosureImageView.snp.height)
        }
    }
    
    private func disclosureButtonConfigurationHandler(_ button: UIButton) {
        button.configuration?.baseBackgroundColor = .clear
        UIView.animate(withDuration: 0.3, animations: {
            self.disclosureImageView.transform = button.isSelected ? CGAffineTransform(rotationAngle: -.pi) : CGAffineTransform(rotationAngle: 0.0001)
        })
    }
    
    private func disclosureButtonPressed(_ action: UIAction) {
        let selected = disclosureButton.isSelected
        setTrainCollectionDisclosed(selected)
    }
    
    private func setDisclosureButtonHidden(_ hidden: Bool) {
        if hidden { disclosureButton.isSelected = false }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.disclosureButton.constraintHeight(hidden ? 0 : 44)
            self?.view.layoutIfNeeded()
        })
    }
    
    //MARK: - Data
    private func updateItems() {
        model.getItems { [weak self] items in
            guard let self else { return }
            
            trainsCollection.items = items
            setTrainCollectionDisclosed(disclosureButton.isSelected)
            
            let disclosureButtonHidden = items.count <= 4
            setDisclosureButtonHidden(disclosureButtonHidden)
        }
    }

}
