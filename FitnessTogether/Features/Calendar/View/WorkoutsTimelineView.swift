
import UIKit

public class WorkoutsTimelineView: UIView {
    
    var timelineView = TimeLineView()
    let workoutsParentView = UIView()
    
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
        isUserInteractionEnabled = true
        setupTimeLineView()
        backgroundColor = .systemBlue
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        constraintHeight(timelineView.intrinsicContentSize.height)
        
    }

    private func setupTimeLineView() {
        self.addSubview(timelineView)
        timelineView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
        }
        timelineView.constraintHeight(500)
        
        timelineView.backgroundColor = .systemBackground
        timelineView.tintColor = .systemGray3
        addView(start: 3600*1, duration: 4*3600)
        addView(start: 3600*17, duration: 5*3600)
        addView(start: 3600*12 , duration: 3600)
        
        addSubview(workoutsParentView)
        workoutsParentView.isUserInteractionEnabled = false
        workoutsParentView.snp.makeConstraints { $0.edges.equalTo(timelineView.scheduleLayoutGuide) }
    }
    
    private func addView(start: Int, duration: Int) {
        let v = UIView()
        v.isUserInteractionEnabled = false
        v.backgroundColor = .systemBlue
        
        workoutsParentView.addSubview(v)
        
        let perDay = (24 * 60 * 60).cgf
        let end = start + duration
        let endOffset = end.cgf / perDay
        let durationOffset = duration.cgf / perDay
        
        v.snp.makeConstraints { maker in
            maker.width.equalToSuperview().dividedBy(timelineView.columnCount)
            maker.leading.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(durationOffset)
            maker.bottom.equalToSuperview().multipliedBy(endOffset)
        }
    }
    
}

public struct WorkoutTimelineItem {
    public
}

fileprivate class WorkoutTimelineItemView {
    
}
