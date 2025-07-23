
import UIKit

public protocol Coordinator: AnyObject {
    
    var currentVC: (UIViewController)? { get }
    var mainVC: UIViewController { get }
    
    func show(_ viewController: UIViewController)
}
