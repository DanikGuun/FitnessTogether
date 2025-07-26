
import UIKit

public class CoachTrainsCollectionCellContentView: UIView, UIContentView {
    public var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    
    private let lineWidth: CGFloat = 2
    
    //MARK: - Lifecycle
    public convenience init(configuration: any UIContentConfiguration){
        self.init(frame: .zero)
        self.configuration = configuration
    }
    public override init(frame: CGRect) {
        configuration = CoachTrainsCellConfiguration()
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        configuration = CoachTrainsCellConfiguration()
        super.init(coder: coder)
    }
    
    private func setupViews() {
        setupImageView()
        setupTitleLabel()
        setupSubtitleLabel()
        DispatchQueue.main.async { [weak self] in self?.backgroundColor = .clear }
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.top.bottom.equalToSuperview()
            maker.width.equalTo(imageView.snp.height)
        }
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalTo(imageView.snp.trailing).offset(8)
            maker.trailing.bottom.equalToSuperview().inset(13)
        }
        titleLabel.font = DC.Font.cellTitle
    }
    
    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { [weak self] maker in
            guard let self = self else { return }
            maker.leading.equalTo(titleLabel.snp.leading)
            maker.trailing.top.equalToSuperview().inset(13)
        }
        subtitleLabel.font = DC.Font.cellSubtitle
        subtitleLabel.textColor = .secondaryLabel
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        imageView.image = conf.image
        titleLabel.text = conf.title
        subtitleLabel.text = conf.subtitle
    }
    
    private func getConfiguration() -> CoachTrainsCellConfiguration {
        if let conf = configuration as? CoachTrainsCellConfiguration {
            return conf
        }
        return CoachTrainsCellConfiguration()
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let inset: CGFloat = 1
        
        let lineFrame = CGRect(
            x: bounds.height/2,
            y: lineWidth*2 + inset,
            width: bounds.width - bounds.height/2 - lineWidth,
            height: bounds.height - lineWidth*4 - inset*2
        )
        let cornerRadius: CGFloat = 15
        let path = UIBezierPath()
        UIColor.ftOrange.setStroke()
        
        let start = CGPoint(x: lineFrame.minX, y: lineFrame.minY)
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
        
        let end = CGPoint(x: lineFrame.minX, y: lineFrame.maxY)
        path.addLine(to: end)
        
        path.lineWidth = lineWidth
        path.stroke()
        
    }
}
