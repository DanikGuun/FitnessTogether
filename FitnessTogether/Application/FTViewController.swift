
import UIKit
import SnapKit

public class FTViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public override var title: String? { didSet { titleLabel.text = title } }
    
    public var isScrollEnable = true { didSet { scrollView.isScrollEnabled = isScrollEnable } }
    public let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupStackView()
        setupNavigationBar()
    }
    
    public func addStackSubview(_ subview: UIView, height: CGFloat, spaceAfter: CGFloat = DC.Layout.spacing) {
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(subview)
        stackView.setCustomSpacing(spaceAfter, after: subview)
    }
    
    public func addSpacing(_ height: CGFloat) {
        let view = UIView()
        view.backgroundColor = .clear
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(view)
        stackView.setCustomSpacing(0, after: view)
    }
    
    private func setupStackView() {
        //Mainscroll
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
    
    private func setupNavigationBar() {
        //BackButton
        navigationItem.hidesBackButton = true
        if navigationController?.viewControllers.first != self {
            let item = UIBarButtonItem(image: UIImage(named: "BackArrow"), style: .plain, target: self, action: #selector(popViewController))
            item.tintColor = .systemGray4
            navigationItem.leftBarButtonItem = item
        }
        
        //Title
        titleLabel.font = DC.Font.roboto(weight: .semibold, size: 24)
        navigationItem.titleView = titleLabel
        
        //Gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc
    private func popViewController() {
        navigationController?.popViewController(animated: true)
    }

}
