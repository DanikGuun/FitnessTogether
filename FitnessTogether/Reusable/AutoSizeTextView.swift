
import UIKit

public class AutoSizeTextView: UITextView {
    
    public override var text: String! { didSet { updateHeight() } }
    
    var maxHeight: CGFloat = 300 { didSet { updateHeight() } }
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    
    public override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        setupObserver()
        updateHeight()
    }
    
    private func setupObserver() {
        NotificationCenter.default.addObserver(
           self,
           selector: #selector(textViewTextDidChange),
           name: UITextView.textDidChangeNotification,
           object: self
       )
    }
    
    @objc
    private func textViewTextDidChange(_ notification: Notification) {
        guard (notification.object as? NSObject) == self else { return }
        updateHeight()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateHeight()
    }
    
    public func updateHeight() {
        let size = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        let height = min(size.height, maxHeight)
        constraintHeight(height)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UITextView.textDidChangeNotification, object: self)
    }
}
