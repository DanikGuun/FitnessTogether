
import UIKit
import FTDomainData

public protocol ProfileViewControllerDelegate {
    func profileVCRequestToAddClient(_ vc: UIViewController, delegate: (any AddClientViewControllerDelegate)?)
    func profileVCDeleteAccount(_ vc: UIViewController)
}

public final class ProfileViewController: FTViewController, AddClientViewControllerDelegate {
    
    public var model: (any ProfileModel)!
    var delegate: (any ProfileViewControllerDelegate)?
    
    let backgroundView = UIView() //задняя верхняя
    let topSpacingView = UIView()
    //let mainBackgroundView = UIView() //все заполнение
    let profileImage = ProfileImageView()
    
    let nameTitleLabel = UILabel()
    let descriptionButton = UIButton(configuration: .plain())
    
    let coachesTitleLabel = UILabel.subHeadline("Тренеры")
    let coachCollection = WorkoutListCollectionView()
    lazy var coachDisclosureButton = DisclosureButton(viewToDisclosure: coachCollection)
    
    let clientsTitleLabel = UILabel.subHeadline("Ученики")
    let clientCollection = WorkoutListCollectionView()
    lazy var clientDisclosureButton = DisclosureButton(viewToDisclosure: clientCollection)
    
    lazy var addClientButton = UIButton.ftFilled(title: "Добавить ученика", handler: addClientButtonPressed)
    
    lazy var deleteAccountButton = UIButton.ftPlain(title: "Удалить аккаунт", handler: deleteAccountButtonPressed)
    
    //MARK: - Lifecycle
    public convenience init(model: (any ProfileModel)) {
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
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
    }
    
    //MARK: - UI
    private func setup() {
        setupBackgroundView()
        setupSpacingView()
        setupScrollView()
        setupProfileImageView()
        setupNameTitle()
        setupDescriptionButton()
        setupCoachesLabel()
        setupCoachesCollection()
        setupClientsLabel()
        setupClientCollection()
        setupAddClientButton()
        setupDeleteAccountButton()
    }
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .systemGray4
        backgroundView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview().priority(.required)
            maker.height.equalTo(210)
        }
    }
    
    private func setupSpacingView() {
        scrollView.addSubview(topSpacingView)
        topSpacingView.backgroundColor = .clear
        topSpacingView.snp.makeConstraints { maker in
            maker.leading.trailing.width.top.equalToSuperview()
            maker.height.equalTo(80)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.remakeConstraints { $0.edges.equalTo(view.safeAreaLayoutGuide) }
        scrollView.clipsToBounds = false
        
        scrollView.addSubview(stackView)
        stackView.snp.remakeConstraints { maker in
            maker.top.equalTo(topSpacingView.snp.bottom)
            maker.leading.trailing.bottom.equalToSuperview()
            maker.width.equalTo(view)
        }
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.layoutMargins = DC.Layout.insets
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.backgroundColor = .systemBackground
        stackView.layer.cornerRadius = 24
        addSpacing(.fixed(80))
    }
    
    private func setupProfileImageView() {
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalTo(stackView.snp.top)
            maker.size.equalTo(CGSize(width: 140, height: 140))
        }
    }
    
    private func setupNameTitle() {
        addStackSubview(nameTitleLabel, spaceAfter: .fixed(0))
        
        nameTitleLabel.textAlignment = .center
        nameTitleLabel.text = "Имени чет нет"
        nameTitleLabel.font = DC.Font.roboto(weight: .medium, size: 20)
    }
    
    private func setupDescriptionButton() {
        addStackSubview(descriptionButton)
        
        let title = NSAttributedString(string: "Подробнее", attributes: [
            .font: DC.Font.roboto(weight: .regular, size: 12)
        ])
        var conf = descriptionButton.configuration
        conf?.baseForegroundColor = .systemGray2
        conf?.attributedTitle = AttributedString(title)
        conf?.image = UIImage(named: "Disclosure")
        conf?.imagePlacement = .trailing
        conf?.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        conf?.imagePadding = 3
        descriptionButton.configuration = conf
        descriptionButton.tintColor = .systemGray2
    }
    
    private func setupCoachesLabel() {
        addStackSubview(coachesTitleLabel)
    }
    
    private func setupCoachesCollection() {
        addStackSubview(coachCollection)
        coachCollection.emptyTitleText = "Тренеров у вас нет("
        
        addStackSubview(coachDisclosureButton)
        coachDisclosureButton.backgroundColor = .clear
    }
    
    private func setupClientsLabel() {
        addStackSubview(clientsTitleLabel)
    }
    
    private func setupClientCollection() {
        addStackSubview(clientCollection)
        clientCollection.emptyTitleText = "У вас нет учеников("
        clientCollection.maximumCollapsedItemsCount = 3
        
        addStackSubview(clientDisclosureButton)
        clientDisclosureButton.backgroundColor = .clear
    }
    
    private func setupAddClientButton() {
        addStackSubview(addClientButton)
    }
    
    private func setupDeleteAccountButton() {
        addStackSubview(deleteAccountButton)
    }
    
    //MARK: - Actions
    private func addClientButtonPressed(_ action: UIAction?) {
        delegate?.profileVCRequestToAddClient(self, delegate: self)
    }
    
    public func addClientVCDidFinish(_ vc: UIViewController) {
        updateData()
    }
    
    private func deleteAccountButtonPressed(_ action: UIAction?) {
        showDeleteAccountAlert()
    }
    
    private func showDeleteAccountAlert() {
        let controller = FTViewController()
        
        controller.addSpacing(.fixed(30))
        controller.addStackSubview(UILabel.headline("Вы уверены, что хотите удалить аккаунт?"))
        controller.addStackSubview(UILabel.additionalInfo("После удаления аккаунта все его данные будут удалены"))
        controller.addStackSubview(UIButton.ftFilled(title: "Нет", handler: { _ in controller.dismiss(animated: true)}))
        controller.addStackSubview(UIButton.ftPlain(title: "Да", handler: deleteAccountApproved))
        
        self.presentPopover(controller, size: CGSize(width: view.frame.width, height: 280), sourceView: view)
    }
    
    private func deleteAccountApproved(_ action: UIAction) {
        model.deleteAccount(completion: { [weak self] isSuccess in
            guard let self else { return }
            if isSuccess {
                delegate?.profileVCDeleteAccount(self)
            }
        })
    }
    
    //MARK: - Data
    func updateData() {
        updateCoaches()
        updateClients()
    }
    
    func updateCoaches() {
        model.getCoaches(completion: { [weak self] coaches in
            guard let self else { return }
            let items = coaches.map(ftUserToItem)
            coachCollection.items = items
        })
    }
    
    func updateClients() {
        model.getClients(completion: { [weak self] clients in
            guard let self else { return }
            let items = clients.map(ftUserToItem)
            clientCollection.items = items
        })
    }
    
    private func ftUserToItem(_ user: FTClientData) -> WorkoutItem {
        return WorkoutItem(
            id: user.id,
            image: nil,
            name: user.lastName + user.firstName,
            date: nil)
    }
    
}

public extension ProfileViewControllerDelegate {
    func profileVCRequestToAddClient(_ vc: UIViewController, delegate: (any AddClientViewControllerDelegate)?) {}
    func profileVCDeleteAccount(_ vc: UIViewController) {}
}
