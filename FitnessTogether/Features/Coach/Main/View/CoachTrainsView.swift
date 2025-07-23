
import UIKit

public protocol CoachTrainsView: UIView {
    var items: [CoachTrainItem] { get set }
    var needShowTitleIfEmpty: Bool { get set }
}

public struct CoachTrainItem {
    var image: UIImage?
    var name: String
    var date: Date
 
    init(image: UIImage? = nil, name: String = "", date: Date = Date()) {
        self.image = image
        self.name = name
        self.date = date
    }
    
}
