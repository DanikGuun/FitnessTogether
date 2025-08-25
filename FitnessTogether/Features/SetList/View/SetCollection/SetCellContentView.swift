
import UIKit

public final class SetCellContentView: UIView, UIContentView, UITextFieldDelegate {
    
    public var configuration: any UIContentConfiguration {
        get {
            var conf = getConfiguration()
            conf.count = Int(countTextfield.text ?? "0") ?? 0
            conf.weight = Int(weightTextfield.text ?? "0") ?? 0
            return conf
        }
        set {
            _configuration = newValue
            updateConfiguration()
        }
    }
    private var _configuration: any UIContentConfiguration = SetCellConfiguration()
    
    let numberLabel = UILabel()
    let countTextfield = UITextField()
    let weightTextfield = UITextField()
    
    //MARK: - Lifecycle
    public convenience init(configuration: UIContentConfiguration) {
        self.init(frame: .zero)
        self.configuration = configuration
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configuration = SetCellConfiguration()
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configuration = SetCellConfiguration()
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        numberLabel.text = conf.number.description
        countTextfield.text = conf.count.description
        weightTextfield.text = conf.weight.description
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
        
        setupNumberLabel(stack: stack)
        setupTextField(countTextfield, stack: stack)
        setupTextField(weightTextfield, stack: stack)
        
        addSubview(stack)
        stack.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupNumberLabel(stack: UIStackView) {
        numberLabel.font = DC.Font.roboto(weight: .regular, size: 16)
        numberLabel.textAlignment = .center
        addVerticalSeparator(to: numberLabel)
        stack.addArrangedSubview(numberLabel)
    }
    
    private func setupTextField(_ textField: UITextField, stack: UIStackView) {
        textField.font = DC.Font.roboto(weight: .regular, size: 16)
        textField.textAlignment = .center
        textField.keyboardType = .decimalPad
        textField.delegate = self
        if textField == countTextfield { addVerticalSeparator(to: textField) }
        stack.addArrangedSubview(textField)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == countTextfield {
            weightTextfield.becomeFirstResponder()
        }
        else if textField == weightTextfield {
            textField.resignFirstResponder()
        }
        return true
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
        if let conf = _configuration as? SetCellConfiguration {
            return conf
        }
        return SetCellConfiguration()
    }

}
