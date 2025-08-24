
import UIKit

public protocol SetCollection: UIView {
    var items: [SetCollectionItem] { get set }
    var didSelectSet: ((SetCollectionItem) -> Void)? { get set }
}

public final class SetCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, SetCollection {

    public var items: [SetCollectionItem] = [] { didSet { reloadData(); updateHeight() } }
    public var didSelectSet: ((SetCollectionItem) -> Void)?
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero, collectionViewLayout: SetCollectionView.makeLayout())
    }
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        delegate = self
        dataSource = self
        clipsToBounds = false
        isScrollEnabled = false
        constraintHeight(1)
    }
    
    //MARK: - Collection
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let item = items[indexPath.item]
        var conf = cell.contentConfiguration as? SetCellConfiguration ?? SetCellConfiguration()
        conf.number = indexPath.item + 1
        conf.count = item.count
        conf.weight = item.weight
        cell.contentConfiguration = conf
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = items[indexPath.item]
        didSelectSet?(item)
    }
    
    //MARK: - Other
    func updateHeight() {
        reloadData()
        layoutIfNeeded()
        constraintHeight(max(contentSize.height, 1))
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(34))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

public struct SetCollectionItem {
    var id: String = ""
    var count: Int = 0
    var weight: Int = 0
}
