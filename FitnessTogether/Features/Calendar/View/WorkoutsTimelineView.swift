
import UIKit

public class WorkoutsTimelineView: TimeLineView {
    
    var items: [WorkoutTimelineItem] = [] { didSet { updateItems() } }
    
    private let workoutsParentView = UIView()
    
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
        backgroundColor = .systemBackground
        tintColor = .systemGray2
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
        setupWorkoutParentView()
    }
    
    private func setupWorkoutParentView() {
        addSubview(workoutsParentView)
        workoutsParentView.snp.makeConstraints { $0.edges.equalTo(scheduleLayoutGuide) }
    }
    
    @objc
    private func handleTap(_ tap: UITapGestureRecognizer) {
        let tapCoodrds = tap.location(in: self)
        guard scheduleLayoutGuide.layoutFrame.contains(tapCoodrds) else { return }
        let tapPoint = workoutsParentView.convert(tapCoodrds, from: self)
        let scheduleFrame = scheduleLayoutGuide.layoutFrame
        let oneColumnWidth = scheduleFrame.width / columnCount.cgf
        let oneRowHeight = scheduleFrame.height / rowCount.cgf
        let column = Int(tapPoint.x / oneColumnWidth)
        let row = Int(tapPoint.y / oneRowHeight)
        
        let time = drawedTimes[row]
        print(column, time)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        constraintHeight(intrinsicContentSize.height)
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
            let columnMultiplier = column.cgf / columnCount.cgf
            
            workoutsParentView.addSubview(itemView)
            itemView.snp.makeConstraints { maker in
                maker.trailing.equalToSuperview().multipliedBy(columnMultiplier)
                maker.width.equalToSuperview().dividedBy(columnCount)
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
