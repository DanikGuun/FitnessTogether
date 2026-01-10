//
//  AnalysisExpandable.swift
//  FitnessTogether
//
//  Created by Sergey Vasilich on 14.12.2025.
//

import UIKit
import FTDomainData


public enum AnalysisListItem: Hashable, Sendable {
    case analysis(AnalysisItem)
    case showAll(Bool)
}

public final class AnalysisExpandableCollectionView: UICollectionView, DisclosableView {
    
    public var fullHeight: CGFloat { max(contentSize.height, emptyItemsLabel.bounds.height) }
    public var maximumCollapsedHeight: CGFloat = 0.0
    public var disclosureButton: DisclosureButton?
    public var isDisclosed: Bool = false
    
    var items: [AnalysisItem] = []
    private let COLLAPSED_MAX_COUNT = 6
    private var isCollapsed = true
    
    var emptyItemsLabel = UILabel()
    
    public var pressItemButtonDelegate: AnalysisItemDelegate?
    
    enum Section: Hashable {
        case main
    }
    
    private var diffableDataSource: UICollectionViewDiffableDataSource<Section, AnalysisListItem>!
    
    public convenience init(){
        self.init(frame: .zero, collectionViewLayout: AnalysisExpandableCollectionView.makeLayout())
    }
    
    public override init(frame: CGRect, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: collectionViewLayout)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setup() {
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        register(AnalysisExpandableCell.self, forCellWithReuseIdentifier: AnalysisExpandableCell.reuseId)
        register(ShowAllCell.self, forCellWithReuseIdentifier: ShowAllCell.reuseId)
        delegate = self
        
        setupDataSource()
        setupEmptyLabel()
    }
    
    
    private func setupDataSource() {
        diffableDataSource = UICollectionViewDiffableDataSource<Section, AnalysisListItem>(collectionView: self) { [weak self] collectionView, indexPath, item in
            
            guard let self else { return UICollectionViewCell() }
            
            switch item {
                
            case .analysis(let analysis):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: AnalysisExpandableCell.reuseId,
                    for: indexPath
                ) as! AnalysisExpandableCell
                cell.configure(analysis)
                cell.delegate = self.pressItemButtonDelegate
                return cell
                
            case .showAll(let isCollapsed):
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: ShowAllCell.reuseId,
                    for: indexPath
                ) as! ShowAllCell
                cell.isCollapsed = isCollapsed
                return cell
            }
        }
    }

    public func applySnapshot(animated: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnalysisListItem>()
        snapshot.appendSections([.main])

        var visibleItems: [AnalysisItem]

        if isCollapsed {
            visibleItems = Array(items.prefix(COLLAPSED_MAX_COUNT))
        } else {
            visibleItems = items
        }

        snapshot.appendItems(visibleItems.map { .analysis($0) })
        if items.count > COLLAPSED_MAX_COUNT {
            snapshot.appendItems([.showAll(isCollapsed)])
        }
        diffableDataSource?.apply(snapshot, animatingDifferences: animated)
        emptyItemsLabel.isHidden = !items.isEmpty
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let item = NSCollectionLayoutItem(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(24)
                )
            )
            let group = NSCollectionLayoutGroup.vertical(
                layoutSize: .init(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(24)
                ),
                subitems: [item]
            )
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 18
            section.contentInsets = .init(top: 8, leading: 24, bottom: 8, trailing: 24)
            return section
        }
    }
    
    private func setupEmptyLabel() {
        addSubview(emptyItemsLabel)
        emptyItemsLabel.snp.makeConstraints { $0.top.centerX.equalToSuperview() }
        
        emptyItemsLabel.font = DC.Font.additionalInfo
        emptyItemsLabel.textColor = .systemGray3
        emptyItemsLabel.text = "Нет данных для анализа"
    }
}

extension AnalysisExpandableCollectionView: UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let visibleCount = isCollapsed ? COLLAPSED_MAX_COUNT : items.count
        if indexPath.item != visibleCount {
            for i in items.indices {
                if i == indexPath.item {
                    items[i].isExpanded.toggle()
                } else {
                    items[i].isExpanded = false
                }
            }
        }
        else {
            isCollapsed = !isCollapsed
        }
        applySnapshot()
    }
}

