
import UIKit
import SnapKit

public final class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, WorkoutTimelineDelegate {
    
    public var model: CalendarModel!
    public var delegate: CalendarViewControllerDelegate?
    
    private let currentDayView = CurrentDayView()
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: CalendarViewController.makeLayout())
    private let addButton = UIButton(configuration: .filled())
    private var weekDateIntervals: [DateInterval] = CalendarViewController.getStartIntervals()
    private var weekDayDates: [Date] = []
    
    public convenience init(model: CalendarModel) {
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
        collection.reloadData()
        
    }
    
    private func setup() {
        setupCurrentDayView()
        setupWorkoutsTimelineCollection()
        setupAddButton()
    }
    
    //MARK: - CurrentDayView
    private func setupCurrentDayView() {
        view.addSubview(currentDayView)
        currentDayView.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(DC.Size.buttonHeight*1.2)
        }
        
        updateCurrentDayItems()
    }
    
    private func updateCurrentDayItems() {
        var interval: DateInterval
        if let index = getCurrentCellIndex() {
            interval = weekDateIntervals[index]
        }
        else {
            interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
        }
        
        setWeekDaysDates(week: interval)
        currentDayView.items = getCurrentDayItems(interval: interval)
        if interval.contains(Date()) { //выделяем, только если инетрвал содержит сегодня, то есть текущая неделя
            currentDayView.selectedItemIndex = (Calendar.actual.component(.weekday, from: Date()) - 2 + 7) % 7
        }
    }
    
    private func setWeekDaysDates(week: DateInterval) {
        weekDayDates.removeAll()
        var date = week.start
        
        while date < week.end {
            weekDayDates.append(date)
            date = date.addingTimeInterval(86400)
        }
    }
    
    private func getCurrentCellIndex() -> Int? {
        let cells = collection.visibleCells
        guard let maxCell = cells.max(by: { collection.bounds.intersection($0.frame).width < collection.bounds.intersection($1.frame).width }) else { return nil }
        let index = collection.indexPath(for: maxCell)!.item
        return index
    }
    
    private func getCurrentDayItems(interval: DateInterval) -> [DayViewItem] {
        var items: [DayViewItem] = []
        let calendar = Calendar.actual
        var date = interval.start
        
        while date < interval.end {
            let day = calendar.component(.day, from: date)
            let weekDay = calendar.component(.weekday, from: date)
            let weekdaySymbol = calendar.veryShortWeekdaySymbols[weekDay - 1]
            items.append(DayViewItem(day: day, weekDay: weekdaySymbol))
            date = date.addingTimeInterval(60 * 60 * 24)
        }
        
        return items
    }
    
    //MARK: - TimeLine
    private func setupWorkoutsTimelineCollection() {
        view.addSubview(collection)
        collection.snp.makeConstraints { maker in
            maker.top.equalTo(currentDayView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
        }
        collection.canCancelContentTouches = false
        collection.showsHorizontalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collection.delegate = self
        collection.dataSource = self
        DispatchQueue.main.async {
            self.collection.scrollToItem(at: IndexPath(item: 2, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weekDateIntervals.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.contentView.setNeedsLayout()
        cell.contentView.layoutIfNeeded()
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        var conf = cell.contentConfiguration as? TimelineCellContentConfiguration ?? TimelineCellContentConfiguration()
        conf.timelineDelegate = self
        conf.shouldSyncHeights = true
        cell.contentConfiguration = conf
        
        let interval = weekDateIntervals[indexPath.item]
        
        model.getItems(for: interval, completion: { items in
            var conf = cell.contentConfiguration as? TimelineCellContentConfiguration ?? TimelineCellContentConfiguration()
            conf.items = items
            cell.contentConfiguration = conf
        })
        
        return cell
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionView = collection
        collectionView.performBatchUpdates({
            updateDateIntervals()
            
            if shouldAddToEnd {
                collectionView.insertItems(at: [IndexPath(item: weekDateIntervals.count-1, section: 0)])
            }
            
            else if shouldAddToStart {
                collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            }
            
        })
    }
    
    private func updateDateIntervals() {
        if shouldAddToEnd {
            let date = weekDateIntervals.last!.end.addingTimeInterval(86400*1)
            let interval = Calendar.current.dateInterval(of: .weekOfYear, for: date)!
            weekDateIntervals.append(interval)
        }
        else if shouldAddToStart {
            let date = weekDateIntervals.first!.start.addingTimeInterval(86400*(-1))
            let interval = Calendar.current.dateInterval(of: .weekOfYear, for: date)!
            weekDateIntervals.insert(interval, at: 0)
        }
    }
    
    private var shouldAddToEnd: Bool {
        collection.contentOffset.x >= collection.contentSize.width - collection.bounds.width*2
    }
    
    private var shouldAddToStart: Bool {
        collection.contentOffset.x < collection.bounds.width*2
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updateCurrentDayItems()
    }
    
    //MARK: - TimelineDelegate
    public func workoutTimeline(_ timeline: WorkoutsTimelineView, didSelect workout: WorkoutTimelineItem) {
        delegate?.calendarViewControllerGoToEditWorkout(self, workoutId: workout.id)
    }
    
    public func timeline(_ timeline: TimeLineView, heightChanged height: CGFloat) {
        TimelineCellContentConfiguration.timelineHeight = height
    }
    
    public func timeline(_ timeline: TimeLineView, contentOffsetChanged contentOffset: CGPoint) {
        TimelineCellContentConfiguration.timelineContentOffset = contentOffset
    }
    
    public func timeline(_ timeline: TimeLineView, didSelectTime components: DateComponents, at column: Int) {
        let startDate = getStartDate(components: components, column: column)
        let interval = model.getTrainInterval(startDate: startDate)
        delegate?.calendarViewControllerGoToAddWorkout(self, interval: interval)
    }
    
    private func getStartDate(components selectedComponents: DateComponents, column: Int) -> Date {
        let selectedDay = weekDayDates[column]
        var components = Calendar.current.allComponents(from: selectedDay)
        components.hour = selectedComponents.hour ?? 0
        components.minute = selectedComponents.minute ?? 0
        let date = Calendar.current.date(from: components)
        return date ?? Date()
    }
    
    //MARK: - AddButton
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.snp.makeConstraints { maker in
            maker.trailing.bottom.equalTo(view.safeAreaLayoutGuide).inset(25)
            maker.width.height.equalTo(50)
        }
        
        let imageConf = UIImage.SymbolConfiguration(weight: .heavy)
        var conf = addButton.configuration
        conf?.baseBackgroundColor = .ftOrange
        conf?.baseForegroundColor = .systemBackground
        conf?.cornerStyle = .capsule
        conf?.image = UIImage(systemName: "plus", withConfiguration: imageConf)
        addButton.configuration = conf
        addButton.addAction(UIAction(handler: addButtonPressed), for: .touchUpInside)
    }
    
    private func addButtonPressed(_ action: UIAction?) {
        delegate?.calendarViewControllerGoToAddWorkout(self, interval: nil)
    }
    
    private static func makeLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        
        let conf = UICollectionViewCompositionalLayoutConfiguration()
        conf.scrollDirection = .horizontal
    
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: conf)
        return layout
    }
    
    private static func getStartIntervals() -> [DateInterval] {
        let week: Double = 60 * 60 * 24 * 7
        let calendar = Calendar.current
        return [
            calendar.dateInterval(of: .weekOfYear, for: Date().addingTimeInterval(week * -2))!,
            calendar.dateInterval(of: .weekOfYear, for: Date().addingTimeInterval(week * -1))!,
            calendar.dateInterval(of: .weekOfYear, for: Date())!,
            calendar.dateInterval(of: .weekOfYear, for: Date().addingTimeInterval(week * 1))!,
            calendar.dateInterval(of: .weekOfYear, for: Date().addingTimeInterval(week * 2))!,
        ]
    }
    
}

public protocol CalendarViewControllerDelegate {
    //интервал, если тыкаем с календаря и надо задать дату.
    func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?)
    func calendarViewControllerGoToEditWorkout(_ viewController: UIViewController, workoutId: String)
}

public extension CalendarViewControllerDelegate {
    func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?) {}
    func calendarViewControllerGoToEditWorkout(_ viewController: UIViewController, workoutId: String) {}
}
