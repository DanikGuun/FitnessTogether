
import UIKit
import SnapKit

public final class CalendarViewController: FTViewController {
    
    var model: CalendarModel!
    
    private let currentDayView = CurrentDayView()
    private let workoutsTimelineView = WorkoutsTimelineView()
    
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
        setupCurrentDayView()
        setupScrollConstraint()
        stackView.layoutMargins = .zero
        setupWorkoutsTimelineView()
        updateItems()
    }
    
    private func setupCurrentDayView() {
        view.addSubview(currentDayView)
        currentDayView.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(DC.Size.buttonHeight*1.2)
        }
        
        currentDayView.items = getCurrentDayItems()
        currentDayView.selectedItemIndex = Calendar.actual.component(.weekday, from: Date()) - 2
    }
    
    private func setupScrollConstraint() {
        scrollView.snp.remakeConstraints { maker in
            maker.top.equalTo(currentDayView.snp.bottom)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
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
    
    private func setupWorkoutsTimelineView() {
        addStackSubview(workoutsTimelineView)
    }
    
    private func updateItems() {
        model.getItems(completion: { [weak self] items in
            self?.workoutsTimelineView.items = items
        })
    }
    
}
