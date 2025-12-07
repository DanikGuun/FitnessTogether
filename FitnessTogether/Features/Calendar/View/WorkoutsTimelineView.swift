
import UIKit

public class WorkoutsTimelineView: TimeLineView {
    
    var items: [WorkoutTimelineItem] = [] { didSet { updateItems() } }
    
    private let workoutsParentView = UIView()
    private let WORKOUT_TIMELINE_TAP_GESTURE = "WorkoutTimeLineTapGesture"
    private let WORKOUT_ITEM_TAP_GESTURE = "WorkoutItemTapGesture"
    
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
        tap.name = WORKOUT_TIMELINE_TAP_GESTURE
        tap.cancelsTouchesInView = false
        tap.delegate = self
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
        processTapToIndexPath(for: tapPoint)
    }
    
    public override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let names = [gestureRecognizer.name, otherGestureRecognizer.name]
        if names.contains(WORKOUT_ITEM_TAP_GESTURE), names.contains(WORKOUT_TIMELINE_TAP_GESTURE) {
            return false
        }
        return super.gestureRecognizer(gestureRecognizer, shouldRecognizeSimultaneouslyWith: otherGestureRecognizer)
    }
    
    private func processTapToIndexPath(for point: CGPoint)  {
        let scheduleFrame = scheduleLayoutGuide.layoutFrame
        let oneColumnWidth = scheduleFrame.width / columnCount.cgf
        let oneRowHeight = scheduleFrame.height / rowCount.cgf
        let column = Int(point.x / oneColumnWidth)
        let row = Int(point.y / oneRowHeight)
        
        let time = drawedTimes[row]
        let date = dateFormatter.date(from: time) ?? Date()
        let components = Calendar.actual.dateComponents([.hour, .minute], from: date)
        
        delegate?.timeline(self, didSelectTime: components, at: column)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        constraintHeight(intrinsicContentSize.height)
    }
    
    private func updateItems() {
        removeAllItemsSubviews()
        let perDay = (24 * 60 * 60).cgf
        
        for item in items {
            let itemView = WorkoutTimelineItemView()
            itemView.item = item
            let tap = UITapGestureRecognizer(target: self, action: #selector(workoutItemDidPressed))
            tap.name = WORKOUT_ITEM_TAP_GESTURE
            itemView.addGestureRecognizer(tap)
            
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
    
    private func removeAllItemsSubviews() {
        workoutsParentView.subviews.forEach { view in
            if let view = view as? WorkoutTimelineItemView {
                view.removeFromSuperview()
            }
        }
    }
    
    @objc
    private func workoutItemDidPressed(_ sender: UITapGestureRecognizer) {
        guard let item = (sender.view as? WorkoutTimelineItemView)?.item,
            let delegate = delegate as? WorkoutTimelineDelegate else { return }
        delegate.workoutTimeline(self, didSelect: item)
        endEditing(true)
    }
    
}

public struct WorkoutTimelineItem {
    public var id: String
    public var title: String
    public var color: UIColor
    public var column: Int
    public var start: TimeInterval
    public var duration: TimeInterval
}


public protocol WorkoutTimelineDelegate: TimelineDelegate {
    func workoutTimeline(_ timeline: WorkoutsTimelineView, didSelect workout: WorkoutTimelineItem)
}

public extension WorkoutTimelineDelegate {
    func workoutTimeline(_ timeline: WorkoutsTimelineView, didSelect workout: WorkoutTimelineItem) {}
}

fileprivate class WorkoutTimelineItemView: UIView {
    
    var item: WorkoutTimelineItem?
    var insets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 4)
    var font = DC.Font.roboto(weight: .medium, size: 12)
    var cornerRadius: CGFloat = 4
    
    private var label = UILabel()
    private var blinkView = UIView() //белая вьюшка(типа прозрачноить)
    
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
    
    //MARK: - UI
    private func setup() {
        setupLabel()
        setupBlinkView()
        DispatchQueue.main.async { self.backgroundColor = .clear }
        
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
    
    private func setupBlinkView() {
        addSubview(blinkView)
        blinkView.backgroundColor = .systemBackground
        blinkView.alpha = 0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
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
        
        blinkView.frame = rectangle
        blinkView.layer.cornerRadius = cornerRadius
    }
    
    //MARK: - Touches
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setAlpha(0.5)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        let value = bounds.contains(touch.location(in: self)) ? 0.5 : 1
        setAlpha(value)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        setAlpha(1)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        setAlpha(1)
    }
    
    private func setAlpha(_ value: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.blinkView.alpha = 1-value
        })
    }
}
