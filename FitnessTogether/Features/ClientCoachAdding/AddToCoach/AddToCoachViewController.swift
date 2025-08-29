
import UIKit

public final class AddToCoachViewController: FTViewController {
    
    var model: AddToCoachModel!
    
    let mainTitle = UILabel()
    let idButton = UIButton(configuration: .plain())
    let clipboardButton = UIButton(configuration: .plain())
    
    var id: String = ""
    
    //MARK: - Lifecycle
    public convenience init(model: AddToCoachModel) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
        setup()
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup() {
        addSpacing(.fixed(50))
        setupMainTitle()
        setupIdButton()
        setupClipboardButton()
    }
    
    private func setupMainTitle() {
        mainTitle.font = DC.Font.roboto(weight: .medium, size: 20)
        mainTitle.text = "Скопируй свой id и отправь тренеру"
        mainTitle.textAlignment = .center
        addStackSubview(mainTitle)
    }
    
    private func setupIdButton() {
        addStackSubview(idButton)
        var conf = idButton.configuration
        
        conf?.attributedTitle = getAttributedTitle("id: ...")
        
        idButton.configuration = conf
        idButton.addAction(UIAction(handler: copyIdToClipboard), for: .touchUpInside)
        updateIdButton()
    }
    
    private func setupClipboardButton() {
        addStackSubview(clipboardButton)
        let imageConf = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold)
        clipboardButton.configuration?.image = UIImage(systemName: "rectangle.portrait.on.rectangle.portrait", withConfiguration: imageConf)
        clipboardButton.configuration?.baseForegroundColor = .systemGreen
        clipboardButton.addAction(UIAction(handler: copyIdToClipboard), for: .touchUpInside)
    }
    
    //MARK: - Actions
    private func updateIdButton() {
        model.getId(completion: { [weak self] id in
            guard let self else { return }
            idButton.configuration?.attributedTitle = getAttributedTitle("id: \(id)")
            self.id = id
        })
    }
    
    private func copyIdToClipboard(_ action: UIAction?) {
        UIPasteboard.general.string = id
    }
    
    private func getAttributedTitle(_ text: String) -> AttributedString {
        let string = NSAttributedString(string: text, attributes: [
            .foregroundColor: UIColor.systemGray3,
            .font: DC.Font.roboto(weight: .medium, size: 16),
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ])
        return AttributedString(string)
    }
    
}
