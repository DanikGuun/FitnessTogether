
import UIKit

public class DateTimeView: UIStackView {
    
    public var date: Date? {
        get { return _date }
        set {
            _date = getRoundedDate(newValue)
            dateButton.date = _date ?? Date()
            updateButtonTitles()
            dateHasChanged?(_date)
        }
    }
    private var _date: Date?
    public var dateHasChanged: ((Date?) -> Void)?
    
    private var dateLabel = UILabel()
    let dateButtonTitleLabel = UILabel() //чтобы сделать кастомный тинт
    private var dateButton = FTDateButton()
    
    private var timeStartLabel = UILabel()
    private var timeStartButton = FTImageAndTitleButton()
    
    private var timeEndLabel = UILabel()
    private var timeEndButton = FTImageAndTitleButton()
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        updateDateLabel()
    }
    
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
        
        let stackView = UIStackView(arrangedSubviews: [dateLabel, dateButton])
        stackView.axis = .vertical
        stackView.distribution = .fill
        dateButton.imageView.image = nil
        
        dateButton.titleLabel.textAlignment = .center
        dateButton.imageView.removeFromSuperview()
        dateButton.titleLabel.text = ""
        
        dateButton.addSubview(dateButtonTitleLabel)
        dateButtonTitleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
        dateButtonTitleLabel.textAlignment = .center
        dateButtonTitleLabel.numberOfLines = 2
        
        dateButton.titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
        dateButton.titleLabel.numberOfLines = 2
        
        return stackView
    }

    private func setupDayIntervalStackView() -> UIStackView {
        setupTitleLabel(timeStartLabel, text: "Время начала")
        setupTitleLabel(timeEndLabel, text: "Время конца")
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
        label.font = DC.Font.headline
        label.text = text
        label.textAlignment = .left
        label.setContentHuggingPriority(.required, for: .vertical)
    }
    
    
    private func setupDateButton() {
        dateButton.addAction(UIAction(handler: dateSelected), for: .valueChanged)
    }
    
    private func setupTimeButton() {
        timeStartButton.titleLabel.text = "чч:мм"
        let conf = UIImage.SymbolConfiguration(weight: .bold)
        timeStartButton.imageView.image = UIImage(systemName: "clock", withConfiguration: conf)
        timeStartButton.addAction(UIAction(handler: timeButtonPressed), for: .touchUpInside)
    }
    
    //MARK: - Actions
    private func dateSelected(_ action: UIAction?) {
        date = dateButton.date
    }
    
    private func timeButtonPressed(_ action: UIAction) {
        let controller = UIDatePicker.ftDatePickerController(pickerMode: .time, startDate: date, handler: timeSelected)
        viewController?.presentPopover(controller, size: CGSize(width: bounds.width, height: 150), sourceView: timeStartButton, arrowDirections: [.down, .up])
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
        updateDateLabel()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "HH:mm"
        timeStartButton.titleLabel.text = formatter.string(from: date ?? Date())
    }
    
    private func updateDateLabel() {
        let isOverlapsed = viewController?.isOverlapsed ?? false
        let formatter = DateFormatter()
        
        formatter.dateFormat = "eeee\ndd"
        formatter.locale = Locale.actual
        let string = formatter.string(from: date ?? Date())
        let attributedTitle = NSMutableAttributedString(string: string)
        
        let spaceLocation = string.firstIndex(of: "\n")!
        let spaceIndex = string.distance(from: string.startIndex, to: spaceLocation)
        let lengthToEnd = string.count - spaceIndex
        
        attributedTitle.setAttributes([
            .foregroundColor: isOverlapsed ? UIColor.systemGray3 : UIColor.label,
            .font: DC.Font.roboto(weight: .semibold, size: 16)
        ], range: NSRange(location: 0, length: spaceIndex))
        
        attributedTitle.setAttributes([
            .foregroundColor: isOverlapsed ? UIColor.systemGray3 : UIColor.systemRed,
            .font: DC.Font.roboto(weight: .semibold, size: 60)
        ], range: NSRange(location: spaceIndex, length: lengthToEnd))
        
        dateButtonTitleLabel.attributedText = attributedTitle
        dateButton.titleLabel.text = ""
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
