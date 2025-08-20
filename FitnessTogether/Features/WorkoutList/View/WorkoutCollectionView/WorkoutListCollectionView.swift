 
import UIKit

public class WorkoutListCollectionView: UIView, WorkoutListView, DisclosableView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    //Disclosing
    public var fullHeight: CGFloat { contentSize.height }
    public var maximumCollapsedHeight: CGFloat = 290
    public weak var disclosureButton: DisclosureButton?
    public var isDisclosed = false
    
    public var items: [WorkoutItem] = [] { didSet { itemsHasUpdated() } }
    public var itemDidPressed: ((WorkoutItem) -> Void)?
    public var needShowTitleIfEmpty: Bool = true
    public var contentSize: CGSize { getContentSize() }
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: WorkoutListCollectionView.makeLayout())
    private var noDataLabel = UILabel()
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.setNeedsLayout()
    }
    
    private func setup() {
        setupCollectionView()
        setupNoDataLabel()
    }
    
    
    //MARK: - CollectionView
    private func setupCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        collectionView.isScrollEnabled = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentConfiguration = getCellConfiguration(for: indexPath)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let item = items[safe: indexPath.item] else { return }
        itemDidPressed?(item)
    }
    
    private func getCellConfiguration(for indexPath: IndexPath) -> FTUserCellConfiguration {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.actual
        dateFormatter.dateFormat = "cccc, HH:mm"
        
        let item = items[indexPath.item]
        var conf = FTUserCellConfiguration()
        conf.image = item.image
        conf.title = item.title
        conf.subtitle = dateFormatter.string(from: item.date).capitalized(with: .actual)
        conf.lineWidth = 1
        return conf
    }
    
    //MARK: - NoData Label
    private func setupNoDataLabel() {
        addSubview(noDataLabel)
        noDataLabel.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview().inset(DC.Layout.insets.top/2)
        }
        noDataLabel.numberOfLines = 0
        noDataLabel.font = DC.Font.additionalInfo
        noDataLabel.textColor = .systemGray4
        noDataLabel.textAlignment = .center
        noDataLabel.text = "Тренировок не запланировано"
    }
    
    //MARK: - Other
    private func itemsHasUpdated() {
        collectionView.reloadData()
        superview?.layoutIfNeeded()
        noDataLabel.isHidden = items.count > 0
    }
    
    private func getContentSize() -> CGSize {
        if items.count < 1 {
            return CGSize(width: bounds.width, height: noDataLabel.bounds.height*2)
        }
        return collectionView.contentSize
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
