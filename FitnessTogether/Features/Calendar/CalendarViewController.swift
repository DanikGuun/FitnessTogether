
import UIKit
import SnapKit

public final class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    public var model: CalendarModel!
    public var delegate: CalendarViewControllerDelegate?
    
    private let currentDayView = CurrentDayView()
    private let collection = UICollectionView(frame: .zero, collectionViewLayout: CalendarViewController.makeLayout())
    private let addButton = UIButton(configuration: .filled())
    
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
        
        currentDayView.items = getCurrentDayItems()
        currentDayView.selectedItemIndex = (Calendar.actual.component(.weekday, from: Date()) - 2 + 7) % 7
    }
    private func getCurrentDayItems() -> [DayViewItem] {
        var items: [DayViewItem] = []
        let calendar = Calendar.actual
        let interval = Calendar.current.dateInterval(of: .weekOfYear, for: Date())!
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
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("end")
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.contentConfiguration = TimelineCellContentConfiguration()

        return cell
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
        
        var conf = UICollectionViewCompositionalLayoutConfiguration()
        conf.scrollDirection = .horizontal
    
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: conf)
        return layout
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 600, height: 800)
//        layout.scrollDirection = .horizontal
//        return layout
    }
    
}

public protocol CalendarViewControllerDelegate {
    //интервал, если тыкаем с календаря и надо задать дату.
    func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?)
}

public extension CalendarViewControllerDelegate {
    func calendarViewControllerGoToAddWorkout(_ viewController: UIViewController, interval: DateInterval?) {}
}
