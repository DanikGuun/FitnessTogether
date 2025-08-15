
import UIKit

public class FTImageAndTitleButton: UIControl {
    
    var titleLabel = UILabel()
    var imageView = UIImageView()
    
    public override var intrinsicContentSize: CGSize { CGSize(width: 150, height: 44) }
    
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
        setupTitleLabel()
        setupImageView()
        backgroundColor = .systemBackground
        makeCornerAndShadow(radius: 14, shadowRadius: 2, opacity: 0.2)
        tintColor = .systemGray2
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(DC.Layout.insets.left)
            maker.top.bottom.equalToSuperview()
        }
        
        titleLabel.font = DC.Font.roboto(weight: .medium, size: 16)
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(DC.Layout.insets.right)
            maker.top.bottom.equalToSuperview().inset(DC.Layout.insets.top)
            maker.width.equalTo(imageView.snp.height)
        }
    }
    
    //MARK: - Touches
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        isHighlighted = true
        updateConfiguration()
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        guard let touch = touches.first else { return }
        isHighlighted = bounds.contains(touch.location(in: self))
        updateConfiguration()
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        isHighlighted = false
        updateConfiguration()
    }

    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        isHighlighted = false
        updateConfiguration()
    }
    
    //
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        imageView.tintColor = tintColor
        titleLabel.textColor = tintColor
        updateConfiguration()
    }
    
    private func updateConfiguration() {
        let shouldHighlight = isHighlighted || viewController?.isOverlapsed ?? false
        alpha = shouldHighlight ? 0.5 : 1
    }
    
}
