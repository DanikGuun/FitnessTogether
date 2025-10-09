
import UIKit

open class FTTabBar: UITabBar {
    
    convenience init() {
        self.init(frame: .zero)
        setupAppearance()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .ftOrange
        
        if #available(iOS 26, *) {
            appearance.stackedLayoutAppearance.normal.iconColor = .label
            appearance.stackedLayoutAppearance.selected.iconColor = .ftOrange
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.label,
                .font: DC.Font.roboto(weight: .semibold, size: 12)
            ]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.ftOrange,
                .font: DC.Font.roboto(weight: .semibold, size: 12)
            ]
        }
        else {
            appearance.stackedLayoutAppearance.normal.iconColor = .systemBackground
            appearance.stackedLayoutAppearance.selected.iconColor = .systemBackground
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
                .foregroundColor: UIColor.systemBackground,
                .font: DC.Font.roboto(weight: .semibold, size: 12)
            ]
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
                .foregroundColor: UIColor.systemBackground,
                .font: DC.Font.roboto(weight: .semibold, size: 12)
            ]
        }
        self.standardAppearance = appearance
        self.scrollEdgeAppearance = appearance
        self.tintColor = .ftOrange
    }
    
}
