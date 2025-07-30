
import UIKit
import SnapKit

public final class CalendarViewController: FTViewController {
    
    private let currentDayView = CurrentDayView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCurrentDayView()
    }
    
    private func setupCurrentDayView() {
        view.addSubview(currentDayView)
        currentDayView.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
            maker.bottom.equalTo(view.safeAreaLayoutGuide.snp.top).offset(DC.Size.buttonHeight)
        }
        
        currentDayView.items = getCurrentDayItems()
        currentDayView.selectedItemIndex = Calendar.actual.component(.weekday, from: Date()) - 2
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
    
}
