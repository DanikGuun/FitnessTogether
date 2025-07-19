
import UIKit

public final class RegistrationViewController: FTViewController{
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let button = UIButton(configuration: .plain())
        addStackSubview(button, height: 40)
        for _ in 0...20 {
            title = "Регситрация"
            let label = UILabel()
            label.text = "Title"
            label.font = DC.Font.roboto(weight: .light, size: 26)
            label.backgroundColor = [UIColor.systemBlue, .systemCyan, .systemPink, .systemRed].randomElement()!
            addStackSubview(label, height: 44)
        }
        
        button.setTitle("go", for: .normal)
        button.addAction(UIAction(handler: { [weak self] _ in
            self?.navigationController?.pushViewController(RegistrationViewController(), animated: true)
        }), for: .touchUpInside)
    }

}

public protocol RegistrationViewControllerDelegate {
    func registrationViewControllerDidFinish(_ controller: RegistrationViewController)
}
