
import UIKit

public class TimeLineView: UIView {
    
    //Appearance
    public var lineWidth: CGFloat = 2 { didSet { layoutIfNeeded() } }
    public var timeFont: UIFont = DC.Font.roboto(weight: .semibold, size: 12) { didSet { layoutIfNeeded() } }
    public var columnCount: Int = 7 { didSet { setNeedsDisplay() } }
    
    //Size
    public var resizeVelocity: CGFloat = 60 { didSet { setNeedsLayout()  } }
    public var minHeight: CGFloat = 400 { didSet { setNeedsLayout() } }
    public var maxHeight: CGFloat = 4000 { didSet { setNeedsLayout()  } }
    public override var intrinsicContentSize: CGSize { bounds.size }

    //Inset
    private var insets: UIEdgeInsets = .zero { didSet { updateScheduleLayoutGuide() } }
    private(set) public var scheduleLayoutGuide = UILayoutGuide() { didSet { layoutIfNeeded() } }
    public override var layoutMargins: UIEdgeInsets { didSet { layoutIfNeeded() } }
    
    //Pinch
    private var startPinchY: CGFloat!
    private var startOffsetY: CGFloat!
    private var startHeight: CGFloat!
    
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
        self.layoutMargins = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
        self.addLayoutGuide(scheduleLayoutGuide)
        updateScheduleLayoutGuide()
        isUserInteractionEnabled = true
        setupPinchGesture()
    }
    
    
    //MARK: - Pinch
    private func setupPinchGesture() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinchGesture))
        self.addGestureRecognizer(pinch)
    }
    @objc
    private func pinchGesture(_ pinch: UIPinchGestureRecognizer) {

        let resize = abs(pinch.scale - 2) * resizeVelocity * (pinch.velocity / 3) //на сколько поменять высоту
        let targetHeight = bounds.height + resize
        let height = targetHeight.clamp(min: minHeight, max: maxHeight)
        constraintHeight(height)
        superview?.layoutIfNeeded()
        
        if let scroll = self.scrollSuperview {
            
            if pinch.state == .began {
                startPinchY =  convert(pinch.location(in: self), to: viewController?.view).y - scroll.frame.minY
                startOffsetY = scroll.contentOffset.y
                startHeight = bounds.height
            }
            
            if bounds.height > scroll.bounds.height {
                let heightPercent = (bounds.height / startHeight) //процент изменения высоты от начала щипка
                let pinchOffset = -(1 - heightPercent) * startPinchY //чтобы скролл держался на уровне вью, от которой начали зумить
                scroll.contentOffset.y = startOffsetY * heightPercent + pinchOffset
            }
        }
    }
    
    //MARK: - Layout
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateInsets()
        let height = bounds.height.clamp(min: minHeight, max: maxHeight)
        if height != bounds.height { constraintHeight(height) }
    }
    
    private func updateInsets() {
        let string = NSString(string: "00:00")
        let width = string.size(withAttributes: [.font: timeFont]).width
        insets.left = width + 10
    }
    
    private func updateScheduleLayoutGuide() {
        scheduleLayoutGuide.snp.remakeConstraints { maker in
            maker.top.equalTo(layoutMarginsGuide).inset(insets.top)
            maker.bottom.equalTo(layoutMarginsGuide).inset(insets.bottom)
            maker.leading.equalTo(layoutMarginsGuide).inset(insets.left)
            maker.trailing.equalTo(layoutMarginsGuide).inset(insets.right)
        }
    }
    
    //MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let drawFrame = layoutMarginsGuide.layoutFrame
        
        tintColor.setFill()
        tintColor.setStroke()
        drawTimeTitlesAndLines(drawFrame: drawFrame)
        drawVerticalLines()
    }
    
    private func drawTimeTitlesAndLines(drawFrame: CGRect) {
        let times = getTimesForDraw()
        let timeHeight = drawFrame.height / (CGFloat(times.count) - 1)
        for (index, time) in times.enumerated() {
            let y = drawFrame.minY + timeHeight * CGFloat(index)
            let x = drawFrame.minX
            let point = CGPoint(x: x, y: y)
            drawTime(time, point: point)
            drawHorizontalLine(at: y)
        }
    }
    
    private func drawTime(_ time: String, point: CGPoint) {
        var point = point
        let time = NSString(string: time)
        let titleSize = time.size(withAttributes: [.font: timeFont])
        point.y -= titleSize.height / 2
        
        time.draw(at: point, withAttributes: [
            .font: timeFont,
            .foregroundColor: tintColor ?? .label
        ])
    }
    
    private func drawHorizontalLine(at y: CGFloat) {
        let bounds = scheduleLayoutGuide.layoutFrame
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: bounds.minX - lineWidth/2, y: y)
        path.move(to: startPoint)
        
        let endPoint = CGPoint(x: bounds.maxX + lineWidth/2, y: y)
        path.addLine(to: endPoint)
        
        path.lineWidth = lineWidth
        path.stroke()
    }
    
    private func getTimesForDraw() -> [String] {
        var titles: [String] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        var currentDate = Calendar.current.startOfDay(for: Date())
        let todayInterval = Calendar.current.dateInterval(of: .day, for: Date())!
        let interval = getTimeLineInterval()
        
        while todayInterval.contains(currentDate) {
            titles.append(dateFormatter.string(from: currentDate))
            currentDate = currentDate.addingTimeInterval(interval)
        }
        return titles
    }
    
    private func getTimeLineInterval() -> TimeInterval {
        let maxIntervalCountPerHour = 4 //макс количество на которые можно разделить час
        let recomendedHeightForTitle: CGFloat = 40
        let heightInterval = layoutMarginsGuide.layoutFrame.height / 24
        let count = Int(heightInterval / recomendedHeightForTitle).clamp(min: 1, max: maxIntervalCountPerHour) //на сколько фрагментов делится час
        let interval: TimeInterval = Double(60 * 60 / count)
        return interval
    }
    
    private func drawVerticalLines() {
        let bounds = scheduleLayoutGuide.layoutFrame
        let step = bounds.width / CGFloat(columnCount)
        
        for column in 0...columnCount+1 {
            let x = bounds.minX + CGFloat(column) * step
            drawVerticalLine(at: x)
        }
    }
    
    private func drawVerticalLine(at x: CGFloat) {
        let bounds = scheduleLayoutGuide.layoutFrame
        let path = UIBezierPath()
        
        let startPoint = CGPoint(x: x, y: bounds.minY)
        path.move(to: startPoint)
        
        let endPoint = CGPoint(x: x, y: bounds.maxY)
        path.addLine(to: endPoint)
        
        path.lineWidth = lineWidth
        path.stroke()
    }
    
}
