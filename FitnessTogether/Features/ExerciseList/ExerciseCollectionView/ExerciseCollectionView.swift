
import UIKit

public final class ExerciseCollectionView: UICollectionView, DisclosableView, UICollectionViewDataSource, UICollectionViewDelegate {
    //Disclosing
    public var fullHeight: CGFloat { max(contentSize.height, emptyItemsLabel.bounds.height) }
    public var maximumCollapsedHeight: CGFloat = 370
    public var disclosureButton: DisclosureButton?
    public var isDisclosed: Bool = false

    var items: [ExerciseCollectionItem] = [] { didSet { itemsHasUpdated() } }
    public var itemDidPressed: ((ExerciseCollectionItem) -> Void)?
    var emptyItemsLabel = UILabel()
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero, collectionViewLayout: ExerciseCollectionView.makeLayout())
    }
    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        disclosureButton?.updateViewHeight()
    }
    
    private func setup() {
        delegate = self
        dataSource = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        isScrollEnabled = false
        setupEmptyLabel()
        itemsHasUpdated()
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let item = items[indexPath.item]
        var conf = (cell.contentConfiguration as? ExerciseCellConfiguration) ?? ExerciseCellConfiguration()
        conf.title = item.title
        conf.subtitle = item.subtitle
        conf.image = item.image
        cell.contentConfiguration = conf
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = items[safe: indexPath.item] else { return }
        itemDidPressed?(item)
    }
    
    private func setupEmptyLabel() {
        addSubview(emptyItemsLabel)
        emptyItemsLabel.snp.makeConstraints { $0.top.centerX.equalToSuperview() }
        
        emptyItemsLabel.font = DC.Font.additionalInfo
        emptyItemsLabel.textColor = .systemGray3
        emptyItemsLabel.text = "Список урпажнений пуст"
    }
    
    private func itemsHasUpdated() {
        reloadData()
        disclosureButton?.isHidden = items.count <= 5
        emptyItemsLabel.isHidden = !items.isEmpty
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(62))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 12
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

public struct ExerciseCollectionItem {
    public var id: String?
    public var title: String?
    public var subtitle: String?
    public var image: UIImage?
}
