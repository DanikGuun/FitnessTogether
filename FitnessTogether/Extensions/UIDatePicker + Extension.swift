
import UIKit

public extension UIDatePicker {
    static func ftDatePickerController(pickerMode: UIDatePicker.Mode, startDate: Date? = nil, handler: @escaping (UIAction) -> ()) -> UIViewController {
        let controller = UIViewController()
        let picker = UIDatePicker()
        controller.view.addSubview(picker)
        picker.addAction(UIAction(handler: handler), for: .valueChanged)
        
        picker.snp.makeConstraints { $0.edges.equalToSuperview() }
        picker.datePickerMode = pickerMode
        picker.preferredDatePickerStyle = .wheels
        picker.locale = Locale.actual
        picker.date = startDate ?? Date()
        picker.minuteInterval = 5
        
        return controller
    }
}
