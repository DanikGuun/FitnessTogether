
import UIKit

public final class LoginViewController: FTViewController {
    
    var delegate: LoginViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        title = "Логин"
    }
    
    
}

public protocol LoginViewControllerDelegate {
    func loginViewControllerDidLogin(_ loginViewController: UIViewController)
}

public extension LoginViewControllerDelegate {
    func loginViewControllerDidLogin(_ loginViewController: UIViewController) {}
}
