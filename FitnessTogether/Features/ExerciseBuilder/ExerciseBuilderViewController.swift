
import UIKit
import FTDomainData

public protocol ExerciseBuilderViewControllerDelegate {
    
}

public final class ExerciseBuilderViewController: FTViewController {
    
    public var delegate: (any ExerciseBuilderViewControllerDelegate)?
    var model: (any ExerciseBuilderModel)!
    
    private var nameTitle = UILabel()
    
    //MARK: - Lifecycle
    public convenience init(model: (any ExerciseBuilderModel)) {
        self.init(nibName: nil, bundle: nil)
        self.model = model
    }
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
    }
    
    private func setupTitle(_ label: UILabel, title text: String) {
        
    }
    
}

public extension ExerciseBuilderViewControllerDelegate {
    
}
