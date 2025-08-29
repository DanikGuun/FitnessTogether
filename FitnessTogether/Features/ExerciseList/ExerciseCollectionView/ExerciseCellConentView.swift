
import UIKit

public final class ExerciseCellConentView: UIView, UIContentView {
    public var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    var titleLabel = UILabel()
    var subtitleLabel = UILabel()
    var imageView = UIImageView()
    
    //MARK: - Lifecycle
    public convenience init(configuration: any UIContentConfiguration) {
        self.init(frame: .zero)
        self.configuration = configuration
    }
    public override init(frame: CGRect) {
        configuration = ExerciseCellConfiguration()
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        configuration = ExerciseCellConfiguration()
        super.init(coder: coder)
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        
        titleLabel.text = conf.title
        titleLabel.textColor = conf.isHighlited ? .systemBackground : .label
        
        
        subtitleLabel.text = conf.subtitle
        subtitleLabel.textColor = conf.isHighlited ? .systemBackground : .systemGray3
        
        imageView.image = conf.image ?? UIImage(systemName: "trophy.circle")
        backgroundColor = conf.isHighlited ? .ftOrange : .systemBackground
    }
    
    private func setup() {
        setupImageView()
        setupSubtitleLabel()
        setupTitleLabel()
        setupAppearance()
    }

    private func setupImageView() {
        addSubview(imageView)
        imageView.snp.makeConstraints { maker in
            maker.top.leading.bottom.equalToSuperview().inset(12)
            maker.width.equalTo(imageView.snp.height)
        }
        
        imageView.layer.cornerRadius = 14
        imageView.tintColor = .systemGray2
    }
    
    private func setupSubtitleLabel() {
        addSubview(subtitleLabel)
        subtitleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(imageView.snp.trailing).offset(DC.Layout.spacing)
            maker.bottom.equalToSuperview().inset(DC.Layout.spacing)
        }
        subtitleLabel.snp.contentHuggingVerticalPriority = 1000
        
        subtitleLabel.font = DC.Font.additionalInfo
        subtitleLabel.numberOfLines = 1
        subtitleLabel.textColor = .systemGray4
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(imageView.snp.trailing).offset(DC.Layout.spacing)
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalTo(subtitleLabel.snp.top).offset(6)
        }
        
        titleLabel.font = DC.Font.roboto(weight: .medium, size: 16)
        titleLabel.numberOfLines = 1
    }
    
    private func setupAppearance() {
        tintColor = .ftOrange
        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 20
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        layer.borderColor = viewController?.isOverlapsed ?? false ? UIColor.systemGray6.cgColor : UIColor.ftOrange.cgColor
    }
    
    private func getConfiguration() -> ExerciseCellConfiguration {
        if let conf = configuration as? ExerciseCellConfiguration {
            return conf
        }
        return ExerciseCellConfiguration()
    }
}
