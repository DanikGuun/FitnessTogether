
import UIKit
import OutlineTextfield

public final class RegistrationViewController: FTViewController {
    
    var delegate: RegistrationViewControllerDelegate?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        for t in 0...20 {
            let text = OutlinedTextfield.ftTextfield(placeholder: "Имя")
            addStackSubview(text, height: DC.Size.buttonHeight)
        }

        
    }
    

}

public protocol RegistrationViewControllerDelegate {
    func registrationViewControllerDidFinish(_ controller: UIViewController)
}

extension RegistrationViewControllerDelegate {
    public func registrationViewControllerDidFinish(_ controller: UIViewController) {}
}
