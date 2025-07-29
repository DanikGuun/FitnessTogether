
import UIKit
import OutlineTextField

public class FTEmailCodeTextField: UIControl, UITextFieldDelegate {
    
    
    var isAllCharactersFilled: Bool {
        return textFields.allSatisfy { ($0.text ?? "").isEmpty == false }
    }
    var isError: Bool = false { didSet { textFields.forEach { $0.isError = isError } } }
    var text: String {
        get {
            textFields.reduce("", { $0 + ($1.text ?? "") })
        }
        set {
            for (index, textField) in textFields.enumerated() {
                guard index < newValue.count else {
                    textField.text = "";
                    continue
                }
                let index = newValue.index(newValue.startIndex, offsetBy: index)
                textField.text = String(newValue[index])
            }
        }
    }
    
    private var textFields: [OutlinedTextField] = []
    
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
        setupTextFields()
    }
    
    private func setupTextFields() {
        let stack = UIStackView()
        addSubview(stack)
        stack.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 12
        
        for _ in 0..<5 {
            let tf = OutlinedTextField.ftTextField()
            applyAppearance(tf)
            textFields.append(tf)
            stack.addArrangedSubview(tf)
        }
    }
    
    private func applyAppearance(_ tf: OutlinedTextField) {
        tf.standartAppearance.outlineCornerRadius = 8
        tf.activeAppearance.outlineCornerRadius = 8
        tf.errorAppearance.outlineCornerRadius = 8
        
        tf.standartAppearance.font = DC.Font.headline
        tf.activeAppearance.font = DC.Font.headline
        tf.errorAppearance.font = DC.Font.headline
        
        tf.standartAppearance.insets = .zero
        tf.activeAppearance.insets = .zero
        tf.errorAppearance.insets = .zero
        
        tf.deleteAction = deleteAction
        tf.textAlignment = .center
        tf.delegate = self
    }

    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        isError = false
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        sendActions(for: .editingChanged)

        if let char = string.last {
            textField.text = String(char)
            goNextTextField()
        }
        else {
            textField.text = ""
            deleteAction(textField as! OutlinedTextField)
        }
        return false
    }
    
    private func deleteAction(_ tf: OutlinedTextField) {
        goPreviousTextField()
    }
    
    private func goNextTextField() {
        let activeTfIndex = textFields.firstIndex(where: { $0.isFirstResponder })!

        if activeTfIndex < textFields.count - 1 {
            let _ = textFields[activeTfIndex + 1].becomeFirstResponder()
        }
        else {
            endEditing(true)
            sendActions(for: .editingDidEnd)
        }
    }
    
    private func goPreviousTextField() {
        let activeTfIndex = textFields.firstIndex(where: { $0.isFirstResponder })!

        if activeTfIndex > 0 {
            let _ = textFields[activeTfIndex - 1].becomeFirstResponder()
        }
    }
}
