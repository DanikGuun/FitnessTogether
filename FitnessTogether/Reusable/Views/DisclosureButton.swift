
import UIKit

public protocol DisclosableView: UIView {
    var fullHeight: CGFloat { get }
    var maximumCollapsedHeight: CGFloat { get }
    var disclosureButton: DisclosureButton? { get set }
    var isDisclosed: Bool { get set }
}

public class DisclosureButton: UIControl {
    
    public var viewToDisclosure: (any DisclosableView)?
    public override var isSelected: Bool { didSet { updateViewHeight() } }
    public override var isHidden: Bool { didSet { setHidden(isHidden) } }
    
    private let label = UILabel()
    private let imageView = UIImageView()
    
    //MARK: - Lifecycle
    public convenience init(viewToDisclosure: (any DisclosableView)?){
        self.init(frame: .zero)
        self.viewToDisclosure = viewToDisclosure
        viewToDisclosure?.disclosureButton = self
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        constraintHeight(DC.Size.smallButtonHeight)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateViewHeight()
    }
    
    private func setup() {
        setupLabel()
        setupImageView()
    }
    
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        label.snp.contentCompressionResistanceVerticalPriority = 250
        label.snp.contentCompressionResistanceHorizontalPriority = 250
        label.snp.contentHuggingHorizontalPriority = 800
        
        label.text = "Показать всё"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = DC.Font.additionalInfo
    }
    
    private func setupImageView() {
        let imageConf = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.right")?.withConfiguration(imageConf)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        
        addSubview(imageView)
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.bottom.equalTo(label).inset(3).priority(.medium)
            maker.leading.equalTo(label.snp.trailing).offset(1)
            maker.width.equalTo(imageView.snp.height)
        }
    }
    
    //MARK: - Actions
    public func updateViewHeight() {
        guard let viewToDisclosure = viewToDisclosure else { return }
        let isDisclosed = self.isSelected
        viewToDisclosure.isDisclosed = isDisclosed
        superview?.layoutIfNeeded()
        scrollSuperview?.layoutIfNeeded()
        
        var height: CGFloat = 0
        if isDisclosed {
            height = viewToDisclosure.fullHeight
        }
        else {
            height = min(viewToDisclosure.maximumCollapsedHeight, viewToDisclosure.fullHeight)
        }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            viewToDisclosure.constraintHeight(max(height, 1))
            self?.superview?.layoutIfNeeded()
            self?.scrollSuperview?.layoutIfNeeded()
        })
    }
    
    private func setHidden(_ hidden: Bool) {
        if hidden { isSelected = false }
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.constraintHeight(hidden ? 0 : DC.Size.smallButtonHeight)
            self?.alpha = hidden ? 0 : 1
            self?.layoutIfNeeded()
            self?.scrollSuperview?.layoutIfNeeded()
        })
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        if bounds.contains(touch.location(in: self)){
            touchUpInside()
        }
        super.touchesEnded(touches, with: event)
    }
    
    private func touchUpInside() {
        isSelected.toggle()
        animateImage()
        updateViewHeight()
    }
    
    //MARK: - Other
    private func animateImage() {
        let angle = self.isSelected ? CGFloat.pi/2 : 0
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.imageView.transform = CGAffineTransform(rotationAngle: angle)
        })
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let start = CGPoint(x: bounds.minX, y: bounds.minY)
        let end = CGPoint(x: bounds.maxX, y: bounds.minY)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = 1
        UIColor.systemGray2.setStroke()
        path.stroke()
    }
    
}
