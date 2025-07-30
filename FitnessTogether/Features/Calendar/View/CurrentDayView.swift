
import UIKit

public final class CurrentDayView: UIView {
    
    var items: [DayViewItem] = [] { didSet { dayItemsHasUpdated() } }
    var selectedItemIndex: Int? { didSet { selectItem() } }
    
    private var stackView = UIStackView()
    private var dayViews: [DayView] { stackView.arrangedSubviews as! [DayView] }
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setupStackView()
        backgroundColor = .systemBackground
        makeCornerAndShadow(radius: 0)
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(DC.Layout.calendarLeftInset)
            maker.top.trailing.bottom.equalToSuperview().inset(DC.Layout.insets.right)
        }
        
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .bottom
    }
    
    private func dayItemsHasUpdated() {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for item in items {
            let view = DayView()
            view.item = item
            view.tintColor = .ftOrange
            stackView.addArrangedSubview(view)
        }
        
    }
    
    private func selectItem() {
        guard selectedItemIndex ?? -1 >= 0, selectedItemIndex ?? -1 < dayViews.count else { return }
        dayViews.forEach { $0.isSelected = false }
        dayViews[selectedItemIndex!].isSelected = true
    }
    
}

fileprivate class DayView: UIView {
    
    var item: DayViewItem? { didSet { self.setNeedsLayout() } }
    var isSelected = false { didSet { self.setNeedsLayout() } }
    override var intrinsicContentSize: CGSize { getIntrinsicContentSize() }
    
    private let weekdayLabel = UILabel()
    private let dayLabel = UILabel()
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutWeekdayLabel()
        layoutDayLabel()
    }
    
    private func layoutDayLabel() {
        dayLabel.text = item?.day.description
        dayLabel.backgroundColor = isSelected ? tintColor : .clear
        dayLabel.textColor = isSelected ? .systemBackground : .label
        dayLabel.layer.masksToBounds = true
        dayLabel.layer.cornerRadius = 10
    }
    
    private func layoutWeekdayLabel() {
        weekdayLabel.text = item?.weekDay
        weekdayLabel.textColor = isSelected ? tintColor : .label
    }
    
    private func setup() {
        setupWeekdaylabel()
        setupDayLabel()
    }
    
    private func setupWeekdaylabel() {
        addSubview(weekdayLabel)
        weekdayLabel.snp.makeConstraints { maker in
            maker.leading.trailing.top.equalToSuperview()
        }
        weekdayLabel.font = DC.Font.roboto(weight: .regular, size: 14)
        weekdayLabel.textAlignment = .center
    }

    private func setupDayLabel() {
        addSubview(dayLabel)
        dayLabel.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.height.equalTo(dayLabel.snp.width)
        }
        dayLabel.font = DC.Font.roboto(weight: .regular, size: 28)
        dayLabel.textAlignment = .center
    }
    
    private func getIntrinsicContentSize() -> CGSize {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let inset: CGFloat = 5
        let width1 = NSString("33").size(withAttributes: [.font: dayLabel.font!]).width
        let width2 = NSString("33").size(withAttributes: [.font: weekdayLabel.font!]).width
        let width = max(width1, width2) + inset*2
        let height = dayLabel.intrinsicContentSize.height + weekdayLabel.intrinsicContentSize.height + inset*2
        return CGSize(width: width, height: height)
    }
    
}

public struct DayViewItem {
    public var day: Int
    public var weekDay: String
}
