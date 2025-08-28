
import UIKit
import OutlineTextField
import FTDomainData

public protocol AddClientViewControllerDelegate {
    func addClientVCDidFinish(_ vc: UIViewController)
}

public final class AddClientViewController: FTViewController {
    var model: (any AddClientModel)!
    var delegate: (any AddClientViewControllerDelegate)?
    
    let titleLabel = UILabel.headline("Добавление ученика")
    let idLabel = UILabel.subHeadline("id ученика")
    let idTextField = OutlinedTextField.ftTextField(placeholder: "id")
    let userPlate = FTUserCellContentView()
    let incorrectLabel = UILabel.incorrectData("Пользователя не существует")
    lazy var addButton = UIButton.ftFilled(title: "Добавить ученика", handler: addButtonDidPressed)
    
    var clientId: String?
    var isUpdating = false
    var timer: Timer?
    
    public override var title: String? { get {titleLabel.text } set { titleLabel.text = newValue } }
    
    //MARK: - Lifecycle
    public convenience init(model: (any AddClientModel)) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        addSpacing(.fixed(16))
        setupTitleLabel()
        setupIdLabel()
        setupTextField()
        setupUserPlate()
        setupAddButton()
    }
    
    private func setupTitleLabel() {
        addStackSubview(titleLabel)
        titleLabel.textAlignment = .center
    }
    
    private func setupIdLabel() {
        addStackSubview(idLabel, spaceAfter: .fixed(16))
        idLabel.textAlignment = .left
        idLabel.font = DC.Font.roboto(weight: .bold, size: 20)
    }
    
    private func setupTextField() {
        addStackSubview(idTextField)
        idTextField.addAction(UIAction(handler: textDidChanged), for: .editingChanged)
        let recogniser = UITapGestureRecognizer(target: self, action: #selector(backgroundViewDidPressed))
        view.addGestureRecognizer(recogniser)
    }
    
    private func setupUserPlate() {
        addStackSubview(userPlate)
        userPlate.constraintHeight(65)
        let conf = FTUserCellConfiguration(title: "ФИО  ученика...")
        userPlate.titleLabel.textColor = .systemGray
        userPlate.configuration = conf
        blinkingUserPlate()
    }
    
    private func setupAddButton() {
        view.addSubview(addButton)
        addButton.isEnabled = false
        addButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(DC.Layout.insets.left)
            maker.bottom.equalTo(view.keyboardLayoutGuide.snp.top).offset(-30)
        }
    }
    
    //MARK: - Animation
    private func setBlinkingUserPlate(_ isUpdating: Bool) {
        self.isUpdating = isUpdating
        blinkingUserPlate()
    }
    
    private func blinkingUserPlate() {
        //туда
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard self?.isUpdating ?? false else { return }
            self?.userPlate.alpha = 0
            
        }, completion: { [weak self] _ in
            //обратно
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: {
                guard self?.isUpdating ?? false else { return }
                self?.userPlate.alpha =  0.6
                
            }, completion: { _ in
                
                //стоп, если надо
                if self?.isUpdating ?? false {
                    self?.blinkingUserPlate()
                }
                
            })
            
        })
        
        if isUpdating == false {
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
                self?.userPlate.alpha = 1
            })
        }
    }
    

    
    //MARK: - Action
    @objc
    private func backgroundViewDidPressed() {
        view.endEditing(true)
    }
    
    private func addButtonDidPressed(_ action: UIAction?) {
        guard let clientId else { return }
        model.addClient(id: clientId, completion: { [weak self] result in
            guard let self else { return }
            switch result {
                
            case .success(_):
                dismiss(animated: true)
                delegate?.addClientVCDidFinish(self)
                
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
    
    private func textDidChanged(_ action: UIAction?) {
        if !isUpdating { setBlinkingUserPlate(true) }
        startGetByIdThrottle()
        setIncorrectIdTextField(false)
    }
    
    private func startGetByIdThrottle() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] _ in
            self?.getUserById()
        })
    }
    
    private func getUserById() {
        let id = idTextField.text ?? ""
        addButton.isEnabled = false
        
        model.getUserById(id: id, completion: { [weak self] user in
            guard let self else { return }
            clientId = id
            updateState(inConwistWith: user)
            setBlinkingUserPlate(false)
        })
        
    }
    
    private func updateState(inConwistWith user: FTClientData?) {
        if let user {
            userPlate.titleLabel.text = user.firstName + " " + user.lastName
            addButton.isEnabled = true
            setIncorrectIdTextField(false)
        }
        else {
            userPlate.titleLabel.text = "Пользователя не существует"
            addButton.isEnabled = false
            setIncorrectIdTextField(true)
        }
    }
    
    private func setIncorrectIdTextField(_ isIncorrect: Bool) {
        idTextField.isError = isIncorrect
        if isIncorrect {
            let textFieldIndex = stackView.arrangedSubviews.firstIndex(of: idTextField) ?? 0
            stackView.insertArrangedSubview(incorrectLabel, at: textFieldIndex + 1)
        }
        else {
            stackView.removeArrangedSubview(incorrectLabel)
            incorrectLabel.removeFromSuperview()
        }
    }
}

public extension AddClientViewControllerDelegate {
    func addClientVCDidFinish(_ vc: UIViewController) {}
}
