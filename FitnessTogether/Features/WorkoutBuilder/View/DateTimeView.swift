
import UIKit

public class DateTimeView: UIStackView {
    
    public var date: Date? {
        get { return _date }
        set {
            _date = getRoundedDate(newValue)
            updateButtonTitles()
            dateHasChanged?(_date)
        }
    }
    private var _date: Date?
    public var dateHasChanged: ((Date?) -> Void)?
    
    private var dateLabel = UILabel()
    private var dateButton = FTDateButton()
    
    private var timeLabel = UILabel()
    private var timeButton = FTImageAndTitleButton()
    
    
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
        setupTitles()
        setupButtons()
        axis = .vertical
    }

    private func setupTitles() {
        setupTitleLabel(dateLabel, text: "Дата")
        setupTitleLabel(timeLabel, text: "Время начала")
        addHorizontalStackView(dateLabel, timeLabel)
    }
    
    private func setupTitleLabel(_ label: UILabel, text: String) {
        label.font = DC.Font.headline
        label.text = text
        label.textAlignment = .center
    }
    
    private func setupButtons() {
        setupDateButton()
        addArrangedSubview(UIView.spaceView(DC.Layout.spacing))
        setupTimeButton()
        addHorizontalStackView(dateButton, timeButton)
    }
    
    private func setupDateButton() {
        dateButton.addAction(UIAction(handler: dateSelected), for: .valueChanged)
    }
    
    private func setupTimeButton() {
        timeButton.titleLabel.text = "чч:мм"
        let conf = UIImage.SymbolConfiguration(weight: .bold)
        timeButton.imageView.image = UIImage(systemName: "clock", withConfiguration: conf)
        timeButton.addAction(UIAction(handler: timeButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Actions
    private func dateSelected(_ action: UIAction?) {
        date = dateButton.date
    }
    
    private func timeButtonPressed(_ action: UIAction) {
        let controller = UIDatePicker.ftDatePickerController(pickerMode: .time, startDate: date, handler: timeSelected)
        viewController?.presentPopover(controller, size: CGSize(width: bounds.width, height: 150), sourceView: timeButton, arrowDirections: [.down, .up])
    }
    
    private func timeSelected(_ action: UIAction) {
        guard let picker = action.sender as? UIDatePicker else { return }
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: picker.date)
        var currentDateComponents = Calendar.current.allComponents(from: date ?? Date())
        currentDateComponents.hour = components.hour
        currentDateComponents.minute = components.minute
        currentDateComponents.second = 0
        
        date = Calendar.current.date(from: currentDateComponents)
    }
    
    private func updateButtonTitles() {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd.MM.yyyy"
        dateButton.titleLabel.text = formatter.string(from: date ?? Date())
        
        formatter.dateFormat = "HH:mm"
        timeButton.titleLabel.text = formatter.string(from: date ?? Date())
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
    
    private func getRoundedDate(_ date: Date?) -> Date? {
        guard let date else { return nil }
        let restTime = date.timeIntervalSince1970.truncatingRemainder(dividingBy: 300) //300 секунд - 5 минут
        return date.addingTimeInterval(-restTime)
    }
    
}
