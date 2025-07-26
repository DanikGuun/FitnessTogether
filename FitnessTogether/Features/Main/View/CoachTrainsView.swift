
import UIKit

public protocol CoachTrainsView: UIView {
    var items: [CoachTrainItem] { get set }
    var contentSize: CGSize { get }
    var needShowTitleIfEmpty: Bool { get set }
}

public struct CoachTrainItem {
    var image: UIImage?
    var title: String
    var date: Date
 
    init(image: UIImage? = nil, name: String = "", date: Date = Date()) {
        self.image = image
        self.title = name
        self.date = date
    }
    
}
