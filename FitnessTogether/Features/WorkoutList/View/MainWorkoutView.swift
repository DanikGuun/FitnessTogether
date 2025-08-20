
import UIKit

public protocol MainWorkoutView: UIView {
    var items: [WorkoutItem] { get set }
    var contentSize: CGSize { get }
    var needShowTitleIfEmpty: Bool { get set }
    var itemDidPressed: ((WorkoutItem) -> Void)? { get set }
}

public struct WorkoutItem {
    var id: String?
    var image: UIImage?
    var title: String
    var date: Date
 
    init(id: String? = nil, image: UIImage? = nil, name: String = "", date: Date = Date()) {
        self.id = id
        self.image = image
        self.title = name
        self.date = date
    }
    
}
