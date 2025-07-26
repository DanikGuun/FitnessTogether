 
import UIKit

public class CoachTrainsCollectionView: UIView, CoachTrainsView, UICollectionViewDelegate, UICollectionViewDataSource {
    public var items: [WorkoutItem] = [] { didSet { itemsHasUpdated() } }
    public var needShowTitleIfEmpty: Bool = true
    public var contentSize: CGSize { getContentSize() }
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: CoachTrainsCollectionView.makeLayout())
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
    
    private func getCellConfiguration(for indexPath: IndexPath) -> CoachTrainsCellConfiguration {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        let item = items[indexPath.item]
        var conf = CoachTrainsCellConfiguration()
        conf.image = item.image
        conf.title = item.title
        conf.subtitle = dateFormatter.string(from: item.date)
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
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
