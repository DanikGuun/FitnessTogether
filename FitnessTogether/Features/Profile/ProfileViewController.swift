
import UIKit
import FTDomainData

public final class ProfileViewController: UIViewController {
    
    public var model: (any ProfileModel)!
    
    private let scrollView = UIScrollView()
    private let backgroundView = UIView() //задняя верхняя
    private let topSpacingView = UIView()
    private let mainBackgroundView = UIView() //все заполнение
    private let profileImage = ProfileImageView()
    
    private let nameTitleLabel = UILabel()
    private let descriptionButton = UIButton(configuration: .plain())
    private let coachesTitleLabel = UILabel.headline("Тренеры")
    private let coachCollection = WorkoutListCollectionView()
    private lazy var coachDisclosureButton = DisclosureButton(viewToDisclosure: coachCollection)
    
    private let clientsTitleLabel = UILabel.headline("Ученики")
    private let clientCollection = WorkoutListCollectionView()
    private lazy var clientDisclosureButton = DisclosureButton(viewToDisclosure: clientCollection)
    
    //MARK: - Lifecycle
    public convenience init(model: (any ProfileModel)) {
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
        updateData()
    }
    
    //MARK: - UI
    private func setup() {
        setupBackgroundView()
        setupScrollView()
        setupSpacingView()
        setupMainBackgroundView()
        setupProfileImageView()
        setupNameTitle()
        setupDescriptionButton()
        setupCoachesLabel()
        setupCoachesCollection()
        setupClientsLabel()
        setupClientCollection()
    }
    private func setupBackgroundView() {
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .systemGray4
        backgroundView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview().priority(.required)
            maker.height.equalTo(210)
        }
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func setupSpacingView() {
        scrollView.addSubview(topSpacingView)
        topSpacingView.backgroundColor = .clear
        topSpacingView.snp.makeConstraints { maker in
            
            maker.top.leading.trailing.width.equalToSuperview().priority(.required)
            maker.height.equalTo(140)
        }
    }
    
    private func setupMainBackgroundView() {
        scrollView.addSubview(mainBackgroundView)
        mainBackgroundView.backgroundColor = .systemBackground
        mainBackgroundView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.width.equalToSuperview()
            maker.top.equalTo(topSpacingView.snp.bottom)
        }
        
        mainBackgroundView.layer.cornerRadius = 24
    }
    
    private func setupProfileImageView() {
        view.addSubview(profileImage)
        profileImage.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.centerY.equalTo(mainBackgroundView.snp.top)
            maker.size.equalTo(CGSize(width: 140, height: 140))
        }
    }
    
    private func setupNameTitle() {
        mainBackgroundView.addSubview(nameTitleLabel)
        nameTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(profileImage.snp.bottom).offset(4)
            maker.leading.trailing.equalToSuperview().inset(12)
        }
        
        nameTitleLabel.textAlignment = .center
        nameTitleLabel.text = "Имени чет нет"
        nameTitleLabel.font = DC.Font.roboto(weight: .medium, size: 20)
    }
    
    private func setupDescriptionButton() {
        mainBackgroundView.addSubview(descriptionButton)
        descriptionButton.snp.makeConstraints { maker in
            maker.top.equalTo(nameTitleLabel.snp.bottom)
            maker.leading.trailing.equalToSuperview().inset(12)
        }
        
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
        mainBackgroundView.addSubview(coachesTitleLabel)
        coachesTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionButton.snp.bottom).offset(26)
            maker.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func setupCoachesCollection() {
        mainBackgroundView.addSubview(coachCollection)
        coachCollection.snp.makeConstraints { maker in
            maker.top.equalTo(coachesTitleLabel.snp.bottom).offset(DC.Layout.spacing)
            maker.leading.trailing.equalToSuperview().inset(DC.Layout.insets.left)
        }
        
        var items: [WorkoutItem] = []
        for i in 0 ..< 5 {
            let item = WorkoutItem(id: nil, image: nil, name: "title \(i)", date: nil)
            items.append(item)
        }
        coachCollection.items = items
        
        mainBackgroundView.addSubview(coachDisclosureButton)
        coachDisclosureButton.backgroundColor = .clear
        coachDisclosureButton.snp.makeConstraints { maker in
            maker.top.equalTo(coachCollection.snp.bottom)
            maker.leading.trailing.equalTo(coachCollection)
        }
    }
    
    private func setupClientsLabel() {
        mainBackgroundView.addSubview(clientsTitleLabel)
        clientsTitleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(coachDisclosureButton.snp.bottom).offset(DC.Layout.spacing)
            maker.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    private func setupClientCollection() {
        mainBackgroundView.addSubview(clientCollection)
        clientCollection.snp.makeConstraints { maker in
            maker.top.equalTo(clientsTitleLabel.snp.bottom).offset(DC.Layout.spacing)
            maker.leading.trailing.equalToSuperview().inset(DC.Layout.insets.left)
        }
        clientCollection.emptyTitleText = "У вас нет учеников("
        
        mainBackgroundView.addSubview(clientDisclosureButton)
        clientDisclosureButton.backgroundColor = .clear
        clientDisclosureButton.snp.makeConstraints { maker in
            maker.top.equalTo(clientCollection.snp.bottom)
            maker.leading.trailing.equalTo(clientCollection)
            maker.bottom.equalToSuperview().priority(50)
        }
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
            clientCollection.items = Array(items) + Array(items)
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
