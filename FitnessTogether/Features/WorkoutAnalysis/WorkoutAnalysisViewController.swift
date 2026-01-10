//
//  WorkoutAnalysisViewController.swift
//  FitnessTogether
//
//  Created by Sergey Vasilich on 14.12.2025.
//

import UIKit
import FTDomainData


public protocol WorkoutAnalysisViewControllerDelegate {
    func analyticsGoToTrain(_ vc: UIViewController)
    func analyticsPostToAnanlyze(_ vc: UIViewController)
}

public final class WorkoutAnalysisViewController: FTViewController, WorkoutAnalysisViewControllerDelegate {
    
    public var model: (any WorkoutAnalysisModel)!
    var delegate: (any WorkoutAnalysisViewControllerDelegate)?
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    
    private var tabbarView = TabBarView(tabs: [
        Tab(id: 0, name: "Анализ"),
        Tab(id: 1, name: "Графики")
    ])
    
    lazy var apiDateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        return df
    }()
    
    lazy var viewDateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMMM yyyy"
        df.locale = Locale(identifier: "ru_RU_POSIX")
        return df
    }()
    
    let collectionView: AnalysisExpandableCollectionView = AnalysisExpandableCollectionView()

    //MARK: - Lifecycle
    public convenience init(model: WorkoutAnalysisModel) {
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
        view.backgroundColor = .systemBackground
        setup()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateItems()
    }
    
    private func updateItems() {
        model?.getWorkoutAnalysis { [weak self] result in
            guard let _self = self else { return }
            _self.collectionView.items.removeAll()
            for item in result {
                let analysisItem = _self.mapToAnalysisItem(item)
                if analysisItem.sections.count == 0 {
                    continue
                }
                _self.collectionView.items.append(analysisItem)
            }
            _self.collectionView.applySnapshot(animated: true)
        }
    }
    
    private func mapToAnalysisItem(_ item: FTUserWorkoutAnalysis) -> AnalysisItem {
        
        var sections: [AnalysisItem.Section] = []
            
        if let activityAnalysis = item.activityAnalysis, !activityAnalysis.isEmpty {
            sections.append(
                AnalysisItem.Section(
                    title: "\(sections.count + 1). Общая активность",
                    text: activityAnalysis)
            )
        }
            
        if let exercisesWithProgress = item.exercisesWithProgress, !exercisesWithProgress.isEmpty {
            sections.append(AnalysisItem.Section(
                title: "\(sections.count + 1). Прогресс",
                text: exercisesWithProgress)
            )
        }
        
        if let growthPoints = item.growthPoints, !growthPoints.isEmpty {
            sections.append(AnalysisItem.Section(
                title: "\(sections.count + 1). Точки роста",
                text: growthPoints)
            )
        }

        if let conclusionAndAdvices = item.conclusionAndAdvices, !conclusionAndAdvices.isEmpty {
            sections.append(AnalysisItem.Section(
                title: "\(sections.count + 1). Выводы и рекомендации",
                text: conclusionAndAdvices)
            )
        }
        
        return AnalysisItem(
            id: item.id,
            title: "Анализ тренеровки",
            date: dateApiToString(date: item.createdAt),
            sections: sections,
            isExpanded: false
        )
    }
    
    private func dateApiToString(date: String) -> String {
        guard let viewDate = apiDateFormatter.date(from: date) else { return "" }
        return viewDateFormatter.string(from: viewDate)
    }
    //MARK: - UI
    private func setup() {
        setupTitle(titleLabel, text: "Аналитика")
        setupSubTitle(subtitleLabel)
        // TODO: отложено, ждём добавления графиков
        // setupTabBar()
        setupCollection()
    }

    private func setupTitle(_ label: UILabel, text: String = "") {
        label.font = DC.Font.headline
        label.text = text
        label.textAlignment = .center
        addStackSubview(label)
    }
    
    private func setupSubTitle(_ label: UILabel, text: String = "") {
        label.font = DC.Font.subHeadline
        label.text = text
        label.textAlignment = .center
        addStackSubview(label)
    }
    
    private func setupTabBar() {
        tabbarView.translatesAutoresizingMaskIntoConstraints = false
        tabbarView.onTabChanged = { tab in
            // TODO: отложено, ждём добавления графиков
            debugPrint("tab selected (id, name):", tab.id, tab.name)
        }
        addStackSubview(tabbarView)
    }
    
    private func setupCollection() {
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            // TODO: отложено, ждём добавления графиков
            // collectionView.topAnchor.constraint(equalTo: tabbarView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor),
            
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        // TODO: rename
        collectionView.applySnapshot(animated: false)
        collectionView.pressItemButtonDelegate = self
    }
}

public extension WorkoutAnalysisViewControllerDelegate {
    func analyticsGoToTrain(_ vc: UIViewController) {}
    func analyticsPostToAnanlyze(_ vc: UIViewController) {}
}

extension WorkoutAnalysisViewController: AnalysisItemDelegate {
    
    public func onPressTainOnAnalyze(_ item: AnalysisItem) {
        self.tabBarController?.selectedIndex = 1
    }
}
