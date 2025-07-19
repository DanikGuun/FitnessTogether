
import UIKit
import SnapKit

public class FTViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public enum SpaceKind {
        case fixed(_ value: CGFloat)
        case fractional(_ percent: CGFloat)
    }
    
    public override var title: String? { didSet { titleLabel.text = title } }
    
    public var isScrollEnable = true { didSet { scrollView.isScrollEnabled = isScrollEnable } }
    public let stackView = UIStackView()
    private let scrollView = UIScrollView()
    private let titleLabel = UILabel()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupStackView()
        setupNavigationBar()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print(123)
    }
    
    public func addStackSubview(_ subview: UIView, height: CGFloat, spaceAfter: SpaceKind = .fixed(DC.Layout.spacing)) {
        subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(subview)
        let space = getSpacing(spacing: spaceAfter)
        stackView.setCustomSpacing(space, after: subview)
    }
    
    public func addSpacing(_ spacing: SpaceKind) {
        let view = UIView()
        view.backgroundColor = .clear
        let height = getSpacing(spacing: spacing)
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        stackView.addArrangedSubview(view)
        stackView.setCustomSpacing(0, after: view)
    }
    
    private func getSpacing(spacing: SpaceKind) -> CGFloat {
        switch spacing {
        case .fixed(let value):
            return value
        case .fractional(let percent):
            return view.bounds.height * percent
        }
    }
    
    public func animateToViews(_ views: [UIView], duration: TimeInterval = 0.6) {
        UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            for subview in self.stackView.arrangedSubviews {
                subview.alpha = 0
                subview.isHidden = true
                subview.transform = CGAffineTransform(translationX: 100, y: -700)
            }
        }, completion: { [weak self] _ in
            
            self?.stackView.arrangedSubviews.forEach { self?.stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
            
            for view in views {
                self?.stackView.addArrangedSubview(view)
                view.alpha = 0
                view.transform = CGAffineTransform(translationX: 0, y: 700)
            }
            
            UIView.animate(withDuration: duration/2, delay: 0, options: .curveEaseInOut, animations: {
                for view in views {
                    view.alpha = 1
                    view.transform = .identity
                }
            })
            
        })
        

    }
    
    private func setupStackView() {
        //Mainscroll
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        scrollView.showsVerticalScrollIndicator = false
        scrollView.keyboardDismissMode = .interactive
        
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
