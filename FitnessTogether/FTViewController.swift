
import UIKit
import SnapKit

public final class FTViewController: UIViewController {
    
    public let stackView = UIStackView()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
    }
    
    private func setupStackView() {
        //Mainscroll
        let scrollView = UIScrollView()
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        scrollView.showsVerticalScrollIndicator = false
        
        //Stack
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
        }
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets.init(top: 0, left: DC.Layout.leadingInset, bottom: 0, right: DC.Layout.trailingInser)
        stackView.spacing = 10
    }
    
    public func addStackSubview(_ subview: UIView, height: CGFloat, spaceAfter: CGFloat = 0) {
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(subview)
        if spaceAfter > 0 { addSpacing(spaceAfter) }
    }
    
    public func addSpacing(_ height: CGFloat) {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(view)
    }
}
