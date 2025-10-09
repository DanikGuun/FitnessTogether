
import SideAlert
import UIKit

public class ErrorPresenter {
    
    public static var activeController: UIViewController?
    
    public static func present(_ error: Error) {
        guard let controller = ErrorPresenter.activeController else { return }
        let alert = SideAlert(title: "Something went wrong(😱)\n\(error.localizedDescription)", color: .error)
        controller.presentSideAlert(alert)
    }
    
}


