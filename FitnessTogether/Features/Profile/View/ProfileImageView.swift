
import UIKit

public final class ProfileImageView: UIView {
    
    public var image: UIImage? {
        get { imageView.image }
        set { imageView.image = newValue }
    }
    public var isOnline: Bool = true { didSet { onlineIndicatorBackgroundView.isHidden = !isOnline } }
    
    let imageView = UIImageView()
    let onlineIndicatorBackgroundView = UIView()
    let onlineIndicatorView = UIView()
    
    private let imageInset: CGFloat = 2
    
    //MARK: - Lifecycle
    public convenience init(){
        self.init(frame: .zero)
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
        DispatchQueue.main.async { [weak self] in
            self?.setup()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.width / 2
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        onlineIndicatorBackgroundView.layer.cornerRadius = onlineIndicatorBackgroundView.bounds.width / 2
        onlineIndicatorView.layer.cornerRadius = onlineIndicatorView.bounds.width / 2
        
        updateOnlineIndicator()
    }
    
    private func updateOnlineIndicator() {
        let radius = imageView.bounds.width / 2 - imageInset
        let x = radius * cos(.pi / 4) + radius
        let y = radius * sin(.pi / 4) + radius
        let point = CGPoint(x: x, y: y)
        onlineIndicatorBackgroundView.center = point
    }
    
    private func setup() {
        backgroundColor = .systemBackground
        setupImageView()
        setupImageView()
        setupOnlineIndicator()
    }
    
    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview().inset(2)
        }
        imageView.image = UIImage(systemName: "person.circle.fill")
        imageView.tintColor = .systemBlue
        imageView.contentMode = .scaleToFill
    }
    
    private func setupOnlineIndicator() {
        addSubview(onlineIndicatorBackgroundView)
        onlineIndicatorBackgroundView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        onlineIndicatorBackgroundView.backgroundColor = .systemBackground
        onlineIndicatorBackgroundView.layer.cornerRadius = 6
        
        onlineIndicatorBackgroundView.addSubview(onlineIndicatorView)
        onlineIndicatorView.snp.makeConstraints { $0.edges.equalToSuperview().inset(2) }
        onlineIndicatorView.backgroundColor = .systemGreen
    }
    
}
