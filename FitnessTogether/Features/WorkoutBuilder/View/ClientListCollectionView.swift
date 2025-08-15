
import UIKit

public class ClientListCollectionView: UICollectionView, DisclosableView, UICollectionViewDelegate, UICollectionViewDataSource  {
    //Disclosing
    public var fullHeight: CGFloat { contentSize.height }
    public var maximumCollapsedHeight: CGFloat = 80
    public var isDisclosed = false
    
    
    public var items: [ClientListItem] = []
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero, collectionViewLayout: ClientListCollectionView.makeLayout())
    }
    
    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        self.dataSource = self
        self.delegate = self
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        var conf = cell.contentConfiguration as? FTUserCellConfiguration ?? FTUserCellConfiguration()
        conf.image = UIImage(systemName: "person.circle")
        conf.attributedTitle = getAttributedTitle(for: indexPath.item)
        cell.contentConfiguration = conf
        
        return cell
    }
    
    private func getAttributedTitle(for index: Int) -> NSAttributedString {
        let text = items[index].title ?? ""
        let string = NSAttributedString(string: text, attributes: [
            .font: DC.Font.roboto(weight: .regular, size: 16)
        ])
        return string
    }

    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(48))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
        group.interItemSpacing = .fixed(DC.Layout.spacing/2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = DC.Layout.spacing/2
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

public struct ClientListItem {
    var id: String = ""
    var title: String?
    var image: UIImage?
}
