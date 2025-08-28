
import UIKit

public final class DateCalendarButton: FTImageAndTitleButton {

    public var date = Date() { didSet { updateTitleLabel() } }
    
    override func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview() }
        
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
    }
    
    override func setupImageView() {}
    
    func updateTitleLabel() {
        let isOverlapsed = viewController?.isOverlapsed ?? false
        let formatter = DateFormatter()
        
        formatter.dateFormat = "eeee\ndd"
        formatter.locale = Locale.actual
        let string = formatter.string(from: date)
        let attributedTitle = NSMutableAttributedString(string: string)
        
        let spaceLocation = string.firstIndex(of: "\n")!
        let spaceIndex = string.distance(from: string.startIndex, to: spaceLocation)
        let lengthToEnd = string.count - spaceIndex
        
        attributedTitle.setAttributes([
            .foregroundColor: isOverlapsed ? UIColor.systemGray3 : UIColor.label,
            .font: DC.Font.roboto(weight: .semibold, size: 16)
        ], range: NSRange(location: 0, length: spaceIndex))
        
        attributedTitle.setAttributes([
            .foregroundColor: isOverlapsed ? UIColor.systemGray3 : UIColor.ftOrange,
            .font: DC.Font.roboto(weight: .semibold, size: 60)
        ], range: NSRange(location: spaceIndex, length: lengthToEnd))
        
        titleLabel.attributedText = attributedTitle
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        updateTitleLabel()
    }
    
}
