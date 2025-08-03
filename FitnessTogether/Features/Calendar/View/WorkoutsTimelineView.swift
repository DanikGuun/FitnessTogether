
import UIKit

public class WorkoutsTimelineView: UIView {
    
    var items: [WorkoutTimelineItem] = [] { didSet { updateItems() } }
    var delegate: (any WorkoutTimeLineDelegate)?
    
    private let timelineView = TimeLineView()
    private let workoutsParentView = UIView()
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        constraintHeight(24)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        isUserInteractionEnabled = true
        setupTimeLineView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc
    private func handleTap(_ tap: UITapGestureRecognizer) {
        let tapCoodrds = tap.location(in: self)
        guard timelineView.scheduleLayoutGuide.layoutFrame.contains(tapCoodrds) else { return }
        let tapPoint = workoutsParentView.convert(tapCoodrds, from: self)
        let scheduleFrame = timelineView.scheduleLayoutGuide.layoutFrame
        let oneColumnWidth = scheduleFrame.width / timelineView.columnCount.cgf
        let oneRowHeight = scheduleFrame.height / timelineView.rowCount.cgf
        let column = Int(tapPoint.x / oneColumnWidth)
        let row = Int(tapPoint.y / oneRowHeight)
        
        let time = timelineView.drawedTimes[row]
        print(column, time)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        constraintHeight(timelineView.intrinsicContentSize.height)
    }

    private func setupTimeLineView() {
        self.addSubview(timelineView)
        timelineView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
        timelineView.constraintHeight(500)
        DispatchQueue.main.async { [weak self] in
            if let minHeight = self?.scrollSuperview?.bounds.height { self?.timelineView.minHeight = minHeight }
        }
        
        timelineView.backgroundColor = .systemBackground
        timelineView.tintColor = .systemGray3
        
        addSubview(workoutsParentView)
        workoutsParentView.isUserInteractionEnabled = false
        workoutsParentView.snp.makeConstraints { $0.edges.equalTo(timelineView.scheduleLayoutGuide) }
    }
    
    private func updateItems() {
        let perDay = (24 * 60 * 60).cgf
        for item in items {
            
            let itemView = WorkoutTimelineItemView()
            itemView.item = item
            
            let durationMultiplier = item.duration / perDay
            let end = item.start + item.duration
            let endMultiplier = end / perDay
            let column = item.column + 1
            let columnMultiplier = column.cgf / timelineView.columnCount.cgf
            
            workoutsParentView.addSubview(itemView)
            itemView.snp.makeConstraints { maker in
                maker.trailing.equalToSuperview().multipliedBy(columnMultiplier)
                maker.width.equalToSuperview().dividedBy(timelineView.columnCount)
                maker.height.equalToSuperview().multipliedBy(durationMultiplier)
                maker.bottom.equalToSuperview().multipliedBy(endMultiplier)
            }
        }
    }
    
}

public struct WorkoutTimelineItem {
    public var title: String
    public var color: UIColor
    public var column: Int
    public var start: TimeInterval
    public var duration: TimeInterval
}

public protocol WorkoutTimeLineDelegate {
    func workoutTimeline(_ timeline: WorkoutTimelineItem, didSelectDate date: Date, column: Int)
}

public extension WorkoutTimeLineDelegate {
    func workoutTimeline(_ timeline: WorkoutTimelineItem, didSelectDate date: Date, column: Int) {}
}

fileprivate class WorkoutTimelineItemView: UIView {
    
    var item: WorkoutTimelineItem?
    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 4)
    var font = DC.Font.roboto(weight: .medium, size: 12)
    var cornerRadius: CGFloat = 4
    
    private var label = UILabel()
    
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
        setupLabel()
    }
    
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview().inset(4)
            maker.bottom.equalToSuperview().priority(.medium)
        }
        label.snp.contentHuggingVerticalPriority = 1000
        label.snp.contentCompressionResistanceVerticalPriority = 0
        
        label.textColor = .systemBackground
        label.numberOfLines = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
        label.attributedText = getLabelTitle()
        setNeedsDisplay()
    }
    
    private func getLabelTitle() -> NSAttributedString {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        paragraph.hyphenationFactor = 0.9
        
        let nsAttributedString = NSAttributedString(string: item?.title ?? "", attributes: [
            .paragraphStyle: paragraph,
            .font: font,
            .foregroundColor: UIColor.systemBackground
        ])
        
        return nsAttributedString
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let rectangle = CGRect(x: rect.minX + insets.left,
                               y: rect.minY + insets.top,
                               width: rect.width - insets.left - insets.right,
                               height: rect.height - insets.top - insets.bottom)
        let path = UIBezierPath(roundedRect: rectangle, cornerRadius: cornerRadius)
        item?.color.setFill()
        path.fill()
    }
    
}
