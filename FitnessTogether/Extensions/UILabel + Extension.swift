
import UIKit

public extension UILabel {
    
    static func incorrectData(_ title: String?) -> UILabel {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = DC.Font.roboto(weight: .regular, size: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = title
        return label
    }
    
    static func headline(_ title: String?) -> UILabel {
        let label = UILabel()
        label.font = DC.Font.headline
        label.text = title
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    static func subHeadline(_ title: String?) -> UILabel {
        let label = UILabel()
        label.font = DC.Font.subHeadline
        label.text = title
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    static func additionalInfo(_ title: String?) -> UILabel {
        let label = UILabel()
        label.font = DC.Font.additionalInfo
        label.text = title
        label.textColor = .systemGray3
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }
    
    static func secondary(_ title: String?) -> UILabel {
        let label = UILabel()
        label.font = DC.Font.roboto(weight: .regular, size: 15)
        label.textColor = UIColor.systemGray3
        label.textAlignment = .center
        return label
    }
    
}
