
import UIKit

public class DateTimeView: UIStackView {
    
    public var dateInterval: DateInterval? {
        get { return _dateInterval }
        set {
            _dateInterval = getRoundedDateInterval(newValue)
            updateButtonTitles()
            dateHasChanged?(_dateInterval)
        }
    }
    private var _dateInterval: DateInterval? = DateInterval() { didSet { updateButtonTitles() } }
    public var dateHasChanged: ((DateInterval?) -> Void)?
    
    private var dateLabel = UILabel()
    private var dateButton = DateCalendarButton()
    
    private var timeStartLabel = UILabel()
    private var timeStartButton = FTImageAndTitleButton()
    
    private var timeEndLabel = UILabel()
    private var timeEndButton = FTImageAndTitleButton()
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - Layout
    private func setup() {
        let dateStack = setupDateStackView()
        let dayIntervalStack = setupDayIntervalStackView()
        addHorizontalStackView(dateStack, dayIntervalStack)
        axis = .vertical
    }
    
    private func setupDateStackView() -> UIStackView {
        setupTitleLabel(dateLabel, text: "Дата")
        setupDateButton()
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, dateButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        
        return stackView
    }

    private func setupDayIntervalStackView() -> UIStackView {
        setupTitleLabel(timeStartLabel, text: "Время начала")
        setupTitleLabel(timeEndLabel, text: "Время конца")
        setupTimeButton(timeStartButton, handler: timeStartButtonPressed)
        setupTimeButton(timeEndButton, handler: timeEndButtonPressed)
        
        let stackView = UIStackView(arrangedSubviews: [
            timeStartLabel,
            timeStartButton,
            UIView.spaceView(DC.Layout.spacing),
            timeEndLabel,
            timeEndButton
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        return stackView
    }
    
    private func setupTitleLabel(_ label: UILabel, text: String) {
        label.font = DC.Font.subHeadline
        label.text = text
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .vertical)
    }
    
    
    private func setupDateButton() {
        dateButton.addAction(UIAction(handler: dateButtonPressed), for: .touchUpInside)
        dateButton.addAction(UIAction(handler: dateSelected), for: .valueChanged)
    }
    
    private func setupTimeButton(_ button: FTImageAndTitleButton, handler: @escaping ((UIAction?) -> Void)) {
        button.titleLabel.text = "чч:мм"
        let conf = UIImage.SymbolConfiguration(weight: .bold)
        button.imageView.image = UIImage(systemName: "clock", withConfiguration: conf)
        button.addAction(UIAction(handler: handler), for: .touchUpInside)
    }
    
    //MARK: - Actions
    private func dateButtonPressed(_ action: UIAction?) {
        let controller = UIDatePicker.ftDatePickerController(pickerMode: .date, startDate: dateInterval?.start, handler: dateSelected)
        viewController?.presentPopover(controller, size: CGSize(width: bounds.width, height: 200), sourceView: timeStartButton, arrowDirections: [.down, .up])
    }
    
    private func dateSelected(_ action: UIAction?) {
        guard let picker = action?.sender as? UIDatePicker else { return }
        
        let components = Calendar.current.dateComponents([.day, .month, .year], from: picker.date)
        var currentStartDateComponents = Calendar.current.allComponents(from: dateInterval?.start ?? Date())
        currentStartDateComponents.day = components.day
        currentStartDateComponents.month = components.month
        currentStartDateComponents.year = components.year
        
        var currentEndDateComponents = Calendar.current.allComponents(from: dateInterval?.end ?? Date())
        currentEndDateComponents.day = components.day
        currentEndDateComponents.month = components.month
        currentEndDateComponents.year = components.year
        
        _dateInterval?.start = Calendar.current.date(from: currentStartDateComponents)!
        _dateInterval?.end = Calendar.current.date(from: currentEndDateComponents)!
        dateButton.date = picker.date
    }
    
    private func timeStartButtonPressed(_ action: UIAction?) {
        let controller = UIDatePicker.ftDatePickerController(pickerMode: .time, startDate: dateInterval?.start, handler: timeStartSelected)
        viewController?.presentPopover(controller, size: CGSize(width: bounds.width, height: 150), sourceView: timeStartButton, arrowDirections: [.down, .up])
    }
    
    private func timeEndButtonPressed(_ action: UIAction?) {
        let controller = UIDatePicker.ftDatePickerController(pickerMode: .time, startDate: dateInterval?.end, handler: timeEndSelected)
        viewController?.presentPopover(controller, size: CGSize(width: bounds.width, height: 150), sourceView: timeEndButton, arrowDirections: [.down, .up])
    }
    
    private func timeStartSelected(_ action: UIAction?) {
        guard let picker = action?.sender as? UIDatePicker else { return }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
        var currentDateComponents = Calendar.current.allComponents(from: dateInterval?.start ?? Date())
        currentDateComponents.hour = components.hour
        currentDateComponents.minute = components.minute
        currentDateComponents.second = 0
        
        let date = Calendar.current.date(from: currentDateComponents) ?? Date()
        let end = _dateInterval?.end ?? Date()
        _dateInterval?.start = date
        _dateInterval?.end = end
    }
    
    private func timeEndSelected(_ action: UIAction?) {
        guard let picker = action?.sender as? UIDatePicker else { return }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
        var currentDateComponents = Calendar.current.allComponents(from: dateInterval?.end ?? Date())
        currentDateComponents.hour = components.hour
        currentDateComponents.minute = components.minute
        currentDateComponents.second = 0
        
        let date = Calendar.current.date(from: currentDateComponents) ?? Date()
        _dateInterval?.end = date
    }
    
    private func updateButtonTitles() {
        dateButton.date = dateInterval?.start ?? Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        let startText = formatter.string(from: dateInterval?.start ?? Date())
        timeStartButton.titleLabel.text = startText
        
        let endText = formatter.string(from: dateInterval?.end ?? Date())
        timeEndButton.titleLabel.text = endText
    }
    
    //MARK: - Additional
    private func addHorizontalStackView(_ views: UIView...) {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = DC.Layout.spacing
        views.forEach { stack.addArrangedSubview($0) }
        addArrangedSubview(stack)
    }
    
    private func getRoundedDateInterval(_ dateInterval: DateInterval?) -> DateInterval? {
        guard let dateInterval else { return nil }
        let startRestTime = dateInterval.start.timeIntervalSince1970.truncatingRemainder(dividingBy: 300) //300 секунд - 5 минут
        let endRestTime = dateInterval.end.timeIntervalSince1970.truncatingRemainder(dividingBy: 300)//300 секунд - 5 минут
        
        let start = dateInterval.start.addingTimeInterval(-startRestTime)
        let end = dateInterval.end.addingTimeInterval(-endRestTime)
        let interval = DateInterval(start: start, end: end)
        
        return interval
    }
    
}
