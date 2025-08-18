
import UIKit
import FTDomainData

public protocol ExerciseBuilderViewControllerDelegate {
    
}

public final class ExerciseBuilderViewController: UIViewController {
    
    public var delegate: (any ExerciseBuilderViewControllerDelegate)?
    var model: (any ExerciseBuilderModel)!
    
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
        view.backgroundColor = .systemBackground
        
        let button = UIButton(configuration: .filled())
        button.setTitle("Добавить", for: .normal)
        button.addAction(UIAction(handler: { _ in
            let exer = FTExerciseCreate(name: "Новая Упражнения ебать", description: "Не ну реально ахуй же")
            self.model.saveExercise(exer, completion: nil)
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        view.addSubview(button)
        button.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
}

public extension ExerciseBuilderViewControllerDelegate {
    
}
