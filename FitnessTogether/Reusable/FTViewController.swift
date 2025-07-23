
import UIKit
import SnapKit

public class FTViewController: UIViewController, UIGestureRecognizerDelegate {
    
    public enum SpaceKind {
        case fixed(_ value: CGFloat)
        case fractional(_ percent: CGFloat)
    }
    
    public enum AnimationDirection {
        case up
        case down
        case left
        case right
        
        var transform: CGAffineTransform {
            switch self {
            case .up: CGAffineTransform(translationX: 0, y: -800)
            case .down: CGAffineTransform(translationX: 0, y: 800)
            case .left: CGAffineTransform(translationX: -500, y: 0)
            case .right: CGAffineTransform(translationX: 500, y: 0)
            }
        }
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
    
    public func addStackSubview(_ subview: UIView, height: CGFloat? = nil, spaceAfter: SpaceKind = .fixed(DC.Layout.spacing)) {
        if let height {
            subview.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
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
    
    public func removeAllStackSubviews(duration: TimeInterval = 0.3, direction: AnimationDirection = .up,
                                  completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            guard let self else { return }
            for subview in self.stackView.arrangedSubviews {
                subview.alpha = 0
                subview.isHidden = true
                subview.transform = direction.transform
            }
        }, completion: { [weak self] _ in
            self?.stackView.arrangedSubviews.forEach { self?.stackView.removeArrangedSubview($0); $0.removeFromSuperview() }
            completion?()
        })
    }
    
    public func addStackSubviews(_ views: [UIView], duration: TimeInterval = 0.3,
                                 direction: AnimationDirection = .up, completion: (() -> Void)? = nil) {

        for view in views {
            stackView.addArrangedSubview(view)
            view.alpha = 0
            view.transform = direction.transform
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseInOut, animations: {
            for view in views {
                view.alpha = 1
                view.transform = .identity
            }
        }, completion: { _ in completion?() })

    }
    
    private func setupStackView() {
        //Mainscroll
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.leading.trailing.top.equalTo(self.view.safeAreaLayoutGuide)
            maker.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
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
        stackView.distribution = .fill
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets.init(top: 0, left: DC.Layout.leadingInset, bottom: 0, right: DC.Layout.trailingInser)
        stackView.spacing = 10
    }
    
    private func setupNavigationBar() {
        //Appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationItem.standardAppearance = appearance
        navigationItem.compactAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationItem.compactScrollEdgeAppearance = appearance
        
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
