
import UIKit

public protocol Coordinator {
    
    var currentVC: (UIViewController)? { get }
    var mainVC: UIViewController { get }
    
    func show(_ viewController: UIViewController)
}
