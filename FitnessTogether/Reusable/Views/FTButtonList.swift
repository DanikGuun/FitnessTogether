
import UIKit

public class FTButtonList: UIControl {
    
    var isSelectingEnable = true { didSet { buttons.forEach { $0.isUserInteractionEnabled = isSelectingEnable } } }
    
    public private(set) var buttons: [UIButton] = []
    public override var intrinsicContentSize: CGSize { CGSize(width: superview?.bounds.width ?? 0, height: 44) }
    
    private var mainScroll = UIScrollView()
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
        if let button = buttons.first(where: { isPointInButton(button: $0, point: point) }) {
            return button
        }
        return super.hitTest(point, with: event)
    }
    
    private func isPointInButton(button: UIButton, point: CGPoint) -> Bool {
        let point = mainScroll.convert(point, from: self)
        return button.frame.contains(point)
    }
    
    //MARK: - UI
    internal func setup() {
        setupMainScroll()
        setupStackView()
        clipsToBounds = false
    }
    
    private func setupMainScroll() {
        addSubview(mainScroll)
        mainScroll.snp.makeConstraints { $0.edges.equalToSuperview() }
        mainScroll.showsHorizontalScrollIndicator = false
        mainScroll.clipsToBounds = false
    }

    private func setupStackView() {
        mainScroll.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.height.equalToSuperview()
        }
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.alignment = .leading
    }
    
    private func configurationUpdateHandler(_ button: UIButton) {
        var conf = button.configuration ?? UIButton.Configuration.plain()
        
        conf.baseBackgroundColor = .systemBackground
        conf.baseForegroundColor = .label
        
        conf.background.strokeColor = button.isSelected ? .ftOrange : .clear
        conf.background.strokeWidth = 1
        conf.background.cornerRadius = 8
        conf.contentInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10).nsInsets
        
        button.configuration = conf
    }
    
    //MARK: - Buttons
    
    public func addButton(withTitle title: String, at index: Int = 0) {
        let button = UIButton(configuration: .filled())
        button.configuration?.title = title
        setupButton(button)
        stackView.insertArrangedSubview(button, at: index)
        buttons.insert(button, at: index)
    }
    
    public func selectButton(at index: Int) {
        buttons.forEach { $0.isSelected = false }
        buttons[index].isSelected = true
    }
    
    public func setButtons(titles: [String]) {
        let buttons = titles.map { title in
            let button = UIButton(configuration: .filled())
            button.configuration?.title = title
            return button
        }
        setButtons(buttons)
    }
    
    public func setButtons(_ buttons: [UIButton]) {
        self.buttons = buttons
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        buttons.forEach(setupButton)
    }
    
    internal func setupButton(_ button: UIButton) {
        
        stackView.addArrangedSubview(button)
        button.configurationUpdateHandler = configurationUpdateHandler
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        button.makeCornerAndShadow(radius: 0, shadowRadius: 2, opacity: 0.2)
        button.addAction(UIAction(handler: buttonPressed), for: .touchUpInside)
        button.isUserInteractionEnabled = isSelectingEnable
        buttons.append(button)
    }
    
    internal func buttonPressed(_ action: UIAction) {
        
    }
}
