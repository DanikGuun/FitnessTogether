
import UIKit

public class WorkoutsTimelineView: UIView {
    
    var items: [WorkoutTimelineItem] = [] { didSet { updateItems() } }
    
    private let timelineView = TimeLineView()
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
        isUserInteractionEnabled = true
        setupTimeLineView()
        backgroundColor = .systemBlue
        
        self.items = [
            WorkoutTimelineItem(title: "Прохор нуб", color: .systemMint, column: 2, start: 9*3600, duration: 3*3600)
        ]
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
        
        timelineView.backgroundColor = .systemBackground
        timelineView.tintColor = .systemGray3
        
        addSubview(workoutsParentView)
        workoutsParentView.isUserInteractionEnabled = false
        workoutsParentView.snp.makeConstraints { $0.edges.equalTo(timelineView.scheduleLayoutGuide) }
    }
    
    private func updateItems() {
        for item in items {
            let perDay = (24 * 60 * 60).cgf
            
            let itemView = WorkoutTimelineItemView()
            itemView.item = item
            let end = item.start + item.duration
            let endOffset = end / perDay
            let durationOffset = item.duration / perDay
            
            workoutsParentView.addSubview(itemView)
            itemView.snp.makeConstraints { maker in
                maker.leading.equalToSuperview()
                maker.width.equalToSuperview().dividedBy(timelineView.columnCount)
                maker.height.equalToSuperview().multipliedBy(durationOffset)
                maker.bottom.equalToSuperview().multipliedBy(endOffset)
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
