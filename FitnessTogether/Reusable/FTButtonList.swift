
import UIKit

public class FTButtonList: UIScrollView {
    
    public var buttonConfigurationUpdateHandler: ((UIButton) -> ())? {
        didSet { buttons.forEach { $0.configurationUpdateHandler = buttonConfigurationUpdateHandler } }
    }
    public private(set) var buttons: [UIButton] = []
    
    private var stackView = UIStackView()
    
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
    
    public override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let button = buttons.first(where: { $0.frame.contains(point) }) {
            return button
        }
        return super.hitTest(point, with: event)
    }
    
    internal func setup() {
        setupStackView()
        clipsToBounds = false
        showsHorizontalScrollIndicator = false
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.height.equalToSuperview()
        }
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .leading
    }
    
    public func setButtons(_ buttons: [UIButton]) {
        self.buttons = buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.forEach { stackView.addArrangedSubview($0) }
        if let updater = buttonConfigurationUpdateHandler {
            buttons.forEach { $0.configurationUpdateHandler = updater }
        }
    }
    
}
