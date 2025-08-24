
import UIKit

public protocol SetListViewControllerDelegate {
    func setListVCDidFinish(_ vc: UIViewController)
    func setListVCRequestToOpenAddSetVC(_ vc: UIViewController, exerciseId: String)
    func setListVCRequestToOpenEditSetVC(_ vc: UIViewController, setId: String, exerciseId: String)
}

public final class SetListViewController: FTViewController {
    public var delegate: (any SetListViewControllerDelegate)?
    public var model: (any SetListModel)!
    
    let mainTitle = UILabel()
    let setListTitle = UILabel()
    let setCollection: SetCollection = SetCollectionView()
    lazy var addSetButton = UIButton.ftPlain(title: "Добавить подход", handler: addSetButtonPressed)
    lazy var finishButton = UIButton.ftFilled(title: "Сохранить", handler: finishButtonPressed)
    
    //MARK: - Lifecycle
    public convenience init(model: (any SetListModel)) {
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
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItems()
    }
    
    //MARK: - UI
    private func setup() {
        setupTitle(mainTitle, text: "Ебическая бомба")
        addSpacing(.fixed(40))
        setupTitle(setListTitle, text: "Список подходов")
        setupCollectionHedline()
        setupSetCollection()
        addSpacing(.fixed(14))
        addStackSubview(addSetButton)
        setupFinishButton()
        addSpacing(.fixed(100))
    }
    
    private func setupTitle(_ label: UILabel, text: String) {
        label.font = DC.Font.headline
        label.textAlignment = .center
        label.text = text
        addStackSubview(label)
    }
    
    private func setupCollectionHedline() {
        func label(_ text: String) -> UILabel {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.font = DC.Font.roboto(weight: .regular, size: 16)
            return label
        }
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.layer.cornerRadius = 11
        stack.layer.borderWidth = 1
        stack.layer.borderColor = UIColor.ftOrange.cgColor
        stack.constraintHeight(32)
        
        stack.addArrangedSubview(label("Номер"))
        stack.addArrangedSubview(label("Кол-во"))
        stack.addArrangedSubview(label("Вес"))
        
        addStackSubview(stack)
    }
    
    private func setupSetCollection() {
        addStackSubview(setCollection)
        var its: [SetCollectionItem] = []
        for _ in 0...10 {
            let item = SetCollectionItem(count: Int.random(in: 1...10), weight: Int.random(in: 1...100))
            its.append(item)
        }
        setCollection.items = its
        setCollection.didSelectSet = setDidSelect
    }
    
    private func setupFinishButton() {
        view.addSubview(finishButton)
        finishButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(DC.Layout.leadingInset)
            maker.bottom.equalToSuperview().inset(40)
        }
    }
    
    //MARK: - Actions
    private func setDidSelect(setItem: SetCollectionItem) {
        delegate?.setListVCRequestToOpenEditSetVC(self, setId: setItem.id, exerciseId: model.exerciseId)
    }
    
    private func addSetButtonPressed(_ action: UIAction?) {
        delegate?.setListVCRequestToOpenAddSetVC(self, exerciseId: model.exerciseId)
    }
    
    private func finishButtonPressed(_ action: UIAction?) {
        delegate?.setListVCDidFinish(self)
    }
    
    private func updateItems() {
        model.getSets(completion: { [weak self] sets in
            let items = sets.map { SetCollectionItem(id: $0.id, count: $0.amount, weight: $0.weight) }
            self?.setCollection.items = items
        })
    }
}

public extension SetListViewControllerDelegate {
    func setListVCDidFinish(_ vc: UIViewController) {}
    func setListVCRequestToOpenAddSetVC(_ vc: UIViewController, exerciseId: String) {}
    func setListVCRequestToOpenEditSetVC(_ vc: UIViewController, setId: String, exerciseId: String) {}
}
