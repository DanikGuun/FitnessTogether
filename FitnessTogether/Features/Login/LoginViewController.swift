
import UIKit

public final class LoginViewController: FTViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

public protocol LoginViewControllerDelegate {
    func loginViewControllerDidLogin(_ loginViewController: UIViewController)
}

public extension LoginViewControllerDelegate {
    func loginViewControllerDidLogin(_ loginViewController: UIViewController) {}
}
