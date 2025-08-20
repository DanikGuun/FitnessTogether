
import UIKit

public final class DateIntervalSelecterView: FTButtonList {
    
    
    lazy var titlesAndIntervals : [(String, DateInterval)] = {
        let calendar = Calendar.current
        let refDate = Date()
        return [
            ("Неделя", intervalToToday(calendar.date(byAdding: .weekOfYear, value: -1, to: refDate))),
            ("Месяц", intervalToToday(calendar.date(byAdding: .month, value: -1, to: refDate))),
            ("3 месяца", intervalToToday(calendar.date(byAdding: .month, value: -3, to: refDate))),
            ("Полгода", intervalToToday(calendar.date(byAdding: .month, value: -6, to: refDate))),
            ("Год", intervalToToday(calendar.date(byAdding: .year, value: -1, to: refDate))),
        ]
    }()
    
    override func setup() {
        super.setup()
        setupButtons()
    }
    
    //MARK: - Buttons
    private func setupButtons() {
        let titles = titlesAndIntervals.map { $0.0 }
        setButtons(titles: titles)
    }
    
    override func setupButton(_ button: UIButton) {
        super.setupButton(button)
        button.changesSelectionAsPrimaryAction = true
    }
    
    override func buttonPressed(_ action: UIAction) {
        guard let button = action.sender as? UIButton else { return }
        buttons.forEach { $0.isSelected = $0 == button }
        sendActions(for: .valueChanged)
    }
    
    //MARK: - Other
    private func intervalToToday(_ start: Date?) -> DateInterval {
        let start = start ?? Date()
        return DateInterval(start: start, end: Date())
    }
    
}
