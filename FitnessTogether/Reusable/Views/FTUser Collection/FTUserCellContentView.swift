
import UIKit

public class FTUserCollectionContentView: UIView, UIContentView {
    public var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let imageMaskLayer = CAShapeLayer()
    
    private let lineWidth: CGFloat = 1
    
    //MARK: - Lifecycle
    public convenience init(configuration: any UIContentConfiguration){
        self.init(frame: .zero)
        self.configuration = configuration
    }
    public override init(frame: CGRect) {
        configuration = FTUserCellConfiguration()
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        configuration = FTUserCellConfiguration()
        super.init(coder: coder)
    }
    
    //MARK: - Layout
    private func setupViews() {
        setupImageView()
        setupSubtitleLabel()
        setupTitleLabel()
        DispatchQueue.main.async { [weak self] in self?.backgroundColor = .clear }
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalToSuperview()
            maker.top.bottom.equalToSuperview().inset(lineWidth)
            maker.width.equalTo(imageView.snp.height)
        }
        
        imageView.contentMode = .scaleToFill
        imageView.layer.mask = imageMaskLayer
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalTo(imageView.snp.trailing).offset(20)
            maker.trailing.equalTo(subtitleLabel.snp.leading).offset(8)
            maker.top.bottom.equalToSuperview()
        }
        titleLabel.snp.contentHuggingHorizontalPriority = 750
        titleLabel.font = DC.Font.cellTitle
    }
    
    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.trailing.equalToSuperview().inset(35).priority(1000)
        }
        subtitleLabel.snp.contentHuggingHorizontalPriority = 1000
        subtitleLabel.font = DC.Font.cellTitle
        subtitleLabel.textColor = .secondaryLabel
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        imageView.image = conf.image
        titleLabel.text = conf.title
        subtitleLabel.text = conf.subtitle
        if let title = conf.attributedTitle { titleLabel.attributedText = title }
        if let subtitle = conf.attributedSubtitle { titleLabel.attributedText = subtitle }
    }
    
    //MARK: - Other
    private func getConfiguration() -> FTUserCellConfiguration {
        if let conf = configuration as? FTUserCellConfiguration {
            return conf
        }
        return FTUserCellConfiguration()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let inset: CGFloat = 3
        let lineFrame = CGRect(
            x: bounds.minX + inset + lineWidth,
            y: bounds.minY + lineWidth*2 + inset,
            width: bounds.width - lineWidth*4 - inset*2,
            height: bounds.height - lineWidth*4 - inset*2
        )
        
        let halfH = lineFrame.height/2
        let cornerRadius: CGFloat = 15
        
        let path = UIBezierPath()
        UIColor.ftOrange.setStroke()
        
        let start = CGPoint(x: lineFrame.minX + halfH, y: lineFrame.minY)
        path.move(to: start)
        
        let rightTopBefore = CGPoint(x: lineFrame.maxX - cornerRadius, y: lineFrame.minY)
        path.addLine(to: rightTopBefore)
        
        let rightTopAfter = CGPoint(x: lineFrame.maxX, y: lineFrame.minY + cornerRadius)
        let rightTopControl = CGPoint(x: lineFrame.maxX, y: lineFrame.minY)
        path.addQuadCurve(to: rightTopAfter, controlPoint: rightTopControl)
        
        let rightBottomBefore = CGPoint(x: lineFrame.maxX, y: lineFrame.maxY - cornerRadius)
        path.addLine(to: rightBottomBefore)
        
        let rightBottomAfter = CGPoint(x: lineFrame.maxX - cornerRadius, y: lineFrame.maxY)
        let rightBottomControl = CGPoint(x: lineFrame.maxX, y: lineFrame.maxY)
        path.addQuadCurve(to: rightBottomAfter, controlPoint: rightBottomControl)
        
        let end = CGPoint(x: lineFrame.minX + halfH, y: lineFrame.maxY)
        path.addLine(to: end)
        
        
        let leftMiddlePoint = CGPoint(x: lineFrame.minX + halfH, y: lineFrame.midY)
        path.addArc(withCenter: leftMiddlePoint, radius: halfH, startAngle: .pi/2, endAngle: .pi*3/2, clockwise: true)
        
        path.lineWidth = lineWidth
        path.stroke()
        
        //обновление маски для картинки
        let diff = lineFrame.minY - lineWidth/2 //разница между началом границ и отрисовкой
        let imageRadius = imageView.bounds.width/2 - diff
        let imageCenter = CGPoint(x: imageView.bounds.width/2, y: imageView.bounds.height/2)
        let maskPath = UIBezierPath(arcCenter: imageCenter, radius: imageRadius, startAngle: 0, endAngle: .pi*2, clockwise: true)

        imageMaskLayer.path = maskPath.cgPath
    }
}
