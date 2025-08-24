
import UIKit

public final class SetCellContentView: UIView, UIContentView {
    public var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    let numberLabel = UILabel()
    let countLabel = UILabel()
    let weightLabel = UILabel()
    
    //MARK: - Lifecycle
    public convenience init(configuration: UIContentConfiguration) {
        self.init(frame: .zero)
        self.configuration = configuration
    }
    public override init(frame: CGRect) {
        configuration = SetCellConfiguration()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        configuration = SetCellConfiguration()
        super.init(coder: coder)
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        numberLabel.text = conf.number.description
        countLabel.text = conf.count.description
        weightLabel.text = conf.weight.description
        backgroundColor = conf.isHighlited ? .ftOrange : .systemBackground
    }
    
    private func setup() {
        selfSetup()
        setupStackView()
    }
    
    private func selfSetup() {
        makeCornerAndShadow(radius: 12, shadowRadius: 2, opacity: 0.2)
    }
    
    private func setupStackView() {
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        
        for label in [numberLabel, countLabel, weightLabel] {
            label.font = DC.Font.roboto(weight: .regular, size: 16)
            label.textAlignment = .center
            if label != weightLabel {
                addVerticalSeparator(to: label)
            }
            stack.addArrangedSubview(label)
        }
        
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func addVerticalSeparator(to view: UIView) {
        let separator = UIView()
        view.addSubview(separator)
        separator.backgroundColor = .systemGray4
        
        separator.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview()
            maker.top.bottom.equalToSuperview().inset(3)
            maker.width.equalTo(1)
        }
    }
    
    private func getConfiguration() -> SetCellConfiguration {
        if let conf = configuration as? SetCellConfiguration {
            return conf
        }
        return SetCellConfiguration()
    }

}
