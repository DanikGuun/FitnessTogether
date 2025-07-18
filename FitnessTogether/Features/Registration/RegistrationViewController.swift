
import UIKit

public final class RegistrationViewController: FTViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        for _ in 0...20 {
            let view = UIView()
            view.backgroundColor = [UIColor.systemBlue, .systemCyan, .systemPink, .systemRed].randomElement()!
            addStackSubview(view, height: 44)
        }
    }
}
