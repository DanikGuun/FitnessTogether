
import UIKit

public class TimelineCellContentView: UIView, UIContentView {
    public var configuration: any UIContentConfiguration { didSet { updateConfiguration() } }
    
    private let timelineView = WorkoutsTimelineView()
    
    convenience init(configuration: any UIContentConfiguration) {
        self.init(frame: .zero)
        self.configuration = configuration
    }
    
    public override init(frame: CGRect) {
        configuration = TimelineCellContentConfiguration()
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init coder")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        timelineView.minHeight = bounds.height
    }
    
    private func updateConfiguration() {
        let conf = getConfiguration()
        timelineView.items = conf.items
        lab.text = conf.count
    }
    
    let lab = UILabel()
    private func setup() {
        setupTimeLine()
        addSubview(lab)
        lab.snp.makeConstraints { $0.leading.trailing.equalToSuperview() }
    }
    
    private func setupTimeLine() {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        addSubview(scroll)
        scroll.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        scroll.addSubview(timelineView)
        timelineView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
        }
    }
    
    private func getConfiguration() -> TimelineCellContentConfiguration {
        if let conf = configuration as? TimelineCellContentConfiguration {
            return conf
        }
        return TimelineCellContentConfiguration()
    }
}
