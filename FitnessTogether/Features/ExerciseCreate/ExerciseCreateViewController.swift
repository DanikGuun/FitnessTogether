
import UIKit
import FTDomainData

public protocol ExerciseCreateViewControllerDelegate {
    func exerciseVC(_ vc: ExerciseCreateViewController, requestToCreate exercise: FTExerciseCreate)
}

public final class ExerciseCreateViewController: UIViewController {
    
    public var delegate: (any ExerciseCreateViewControllerDelegate)?
    
    public override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        
        let button = UIButton(configuration: .filled())
        button.setTitle("Добавить", for: .normal)
        button.addAction(UIAction(handler: { _ in
            let exer = FTExerciseCreate(name: "Новая Упражнения ебать", description: "Не ну реально ахуй же")
            self.delegate?.exerciseVC(self, requestToCreate: exer)
            self.dismiss(animated: true)
        }), for: .touchUpInside)
        
        view.addSubview(button)
        button.snp.makeConstraints { $0.center.equalToSuperview() }
    }
    
}

public extension ExerciseCreateViewControllerDelegate {
    func exerciseVC(_ vc: ExerciseCreateViewController, requestToCreate exercise: FTExerciseCreate) {}
}
