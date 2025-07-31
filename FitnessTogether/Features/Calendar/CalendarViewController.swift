
import UIKit
import SnapKit

public final class CalendarViewController: FTViewController {
    
    private let currentDayView = CurrentDayView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCurrentDayView()
        setupScrollConstraint()
        stackView.layoutMargins = .zero
        setupScheduleView()
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
    
    private func setupScheduleView() {
        let v = TimeLineView()
        v.backgroundColor = .systemBackground
        v.tintColor = .systemGray4
        DispatchQueue.main.async { [weak self] in v.minHeight = (self?.scrollView.bounds.height ?? 400) * 0.9}
        addStackSubview(v, height: 2000)
    }
    
}
