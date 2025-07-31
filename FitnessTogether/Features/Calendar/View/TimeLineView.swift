
import UIKit

public class TimeLineView: UIView {
    
    //Size
    public var resizeVelocity: CGFloat = 60 { didSet { layoutIfNeeded() } }
    public var minHeight: CGFloat = 400 { didSet { layoutIfNeeded() } }
    public var maxHeight: CGFloat = 4000 { didSet { layoutIfNeeded() } }

    //Inset
    private var insets: UIEdgeInsets = .zero { didSet { updateScheduleLayoutGuide() } }
    private(set) public var scheduleLayoutGuide = UILayoutGuide() { didSet { layoutIfNeeded() } }
    public override var layoutMargins: UIEdgeInsets { didSet { layoutIfNeeded() } }
    
    //Font
    public var timeFont: UIFont = DC.Font.additionalInfo { didSet { layoutIfNeeded(); setNeedsDisplay() } }
    
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
        
        let resize = abs(pinch.scale - 1) * resizeVelocity * (pinch.velocity / 3) //на сколько поменять высоту
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
            
            let heightPercent = (bounds.height / startHeight) //процент изменения высоты от начала щипка
            let pinchOffset = -(1 - heightPercent) * startPinchY
            scroll.contentOffset.y = startOffsetY * heightPercent + pinchOffset
        }
    }
    
    private func updateScheduleLayoutGuide() {
        scheduleLayoutGuide.snp.remakeConstraints { maker in
            maker.top.equalTo(layoutMarginsGuide).inset(insets.top)
            maker.bottom.equalTo(layoutMarginsGuide).inset(insets.bottom)
            maker.leading.equalTo(layoutMarginsGuide).inset(insets.left)
            maker.trailing.equalTo(layoutMarginsGuide).inset(insets.right)
        }
    }
    //
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let drawFrame = layoutMarginsGuide.layoutFrame
        let scheduleFrame = scheduleLayoutGuide.layoutFrame
        
        tintColor.setFill()
        tintColor.setStroke()
        drawTimeTitles(drawFrame: drawFrame)
    }
    
    private func drawTimeTitles(drawFrame: CGRect) {
        let times = getTimesForDraw()
        let timeHeight = drawFrame.height / CGFloat(times.count)
        for (index, time) in times.map({ NSString(string: $0) }).enumerated() {
            let targetY = drawFrame.minY + timeHeight * CGFloat(index)
            let titleSize = time.size(withAttributes: [.font: timeFont])
            let y = targetY - titleSize.height / 2
            let x = drawFrame.minX
            let point = CGPoint(x: x, y: y)
            time.draw(at: point, withAttributes: [
                .font: timeFont,
                .foregroundColor: tintColor ?? .label
            ])
        }
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
    
}
