
import UIKit

public final class ComplexitySlider: UIControl {
    
    public override var intrinsicContentSize: CGSize { CGSize(width: 150, height: DC.Size.buttonHeight) }
    public var fill: Double = 0.0 { didSet { setNeedsDisplay() } }
    
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
        DispatchQueue.main.async { [weak self] in self?.backgroundColor = .clear }
        layer.cornerRadius = DC.Size.buttonCornerRadius / 2
    }
    
    //MARK: - Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        setFillByTouches(touches)
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        setFillByTouches(touches, animated: false)
    }
    
    private func setFillByTouches(_ touches: Set<UITouch>, animated: Bool = true) {
        guard let touch = touches.first else { return }
        let fill = touch.location(in: self).x / bounds.width
        self.fill = fill.clamp(min: 0.0, max: 1.0)
        sendActions(for: .valueChanged)
    }
    
    //MARK: - Drawing
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawBackground()
        drawGradient()
    }
    
    private func drawBackground() {
        let cornerRadius = layer.cornerRadius
        let backgroundPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        UIColor.systemGray6.setFill()
        backgroundPath.fill()
    }
    
    private func drawGradient() {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        clipContextByRoundingCorners(context)
        clipContextByFilling(context)
        
        let start = CGPoint(x: 0, y: bounds.midY)
        let end = CGPoint(x: bounds.maxX, y: bounds.midY)
        context.drawLinearGradient(getGradient(), start: start, end: end, options: [])
    }
    
    private func clipContextByRoundingCorners(_ context: CGContext) {
        let cornerRadius = layer.cornerRadius
        let clipPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        context.addPath(clipPath.cgPath)
        context.clip()
    }
    
    private func clipContextByFilling(_ context: CGContext) {
        let width = bounds.width * fill.clamp(min: 0.0, max: 1.0)
        let rect = CGRect(x: 0, y: 0, width: width, height: bounds.height)
        let path = UIBezierPath(rect: rect)
        context.addPath(path.cgPath)
        
        context.clip()
    }
    
    private func getGradient() -> CGGradient {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors: CFArray = [UIColor.systemGreen.cgColor, UIColor.systemYellow.cgColor, UIColor.systemRed.cgColor] as! CFArray
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: [0, 0.5, 1])!
        return gradient
    }
    
}
