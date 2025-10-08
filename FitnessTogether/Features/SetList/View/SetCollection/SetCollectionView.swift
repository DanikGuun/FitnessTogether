
import UIKit

public protocol SetCollection: UIView {
    var items: [SetCollectionItem] { get set }
    var didSelectSet: ((SetCollectionItem) -> Void)? { get set }
    func appendItem()
}

public final class SetCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, SetCollection {

    public var items: [SetCollectionItem] {
        get {
            return getCurrentItems()
        }
        set {
            _items = newValue
            reloadData()
            updateHeight()
        }
    }
    private var _items: [SetCollectionItem] = []
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
        return _items.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let item = _items[indexPath.item]
        var conf = cell.contentConfiguration as? SetCellConfiguration ?? SetCellConfiguration()
        conf.number = item.number
        conf.count = item.count
        conf.weight = item.weight
        cell.contentConfiguration = conf
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = _items[indexPath.item]
        didSelectSet?(item)
    }
    
    public func appendItem() {
        var oldItems = items
        let newItem = SetCollectionItem(id: nil, number: oldItems.count + 1, count: 0, weight: 0)
        oldItems.append(newItem)
        items = oldItems
    }
    
    private func getCurrentItems() -> [SetCollectionItem] {
        var collectionItems: [SetCollectionItem] = []
        
        for index in 0 ..< _items.count {
            guard let cell = cellForItem(at: IndexPath(item: index, section: 0)),
                  let conf = cell.contentConfiguration as? SetCellConfiguration else { return [] }
            
            let id = _items[index].id
            let item = SetCollectionItem(id: id, number: index + 1, count: conf.count, weight: conf.weight)
            collectionItems.append(item)
        }
        
        return collectionItems
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
    var id: String? = nil
    var number: Int = 0
    var count: Int = 0
    var weight: Int = 0
}
