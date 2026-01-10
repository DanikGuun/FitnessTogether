//
//  TabBarView.swift
//  FitnessTogether
//
//  Created by Sergey Vasilich on 14.12.2025.
//

import UIKit


struct Tab {
    public var id: Int
    public var name: String
}

final class TabBarView: UIView {
    
    var onTabChanged: ((Tab) -> Void)?
    
    private var tabs: [Tab] = []
    
    private var buttons: [UIButton] = []
    
    private let containerView = UIView()
    private let selectionView = UIView()
    private var selectionLeadingConstraint: NSLayoutConstraint!

    private(set) var currentTabId: Int = 0 {
        didSet {
            updateUI(animated: true)
        }
    }
    
    // MARK: - Init

    init(tabs: [Tab] = []) {
        super.init(frame: .zero)
        self.tabs = tabs
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }


    // MARK: - Setup views
    private func setupViews() {
        
        backgroundColor = .white

        containerView.backgroundColor = .white
        containerView.layer.borderColor = CGColor(gray: 0.85, alpha: 1)
        containerView.layer.borderWidth = 1
        containerView.layer.cornerRadius = 22
        containerView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(containerView)
        
        selectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        selectionView.layer.cornerRadius = 22
        selectionView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(selectionView)
        
        for tab in tabs {
            
            let button = UIButton(type: .system)
            button.setTitle(tab.name, for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 18, weight: .medium)
            button.tag = tab.id
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            
            buttons.append(button)
        }
        
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stack)

        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalToConstant: 44),
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            stack.topAnchor.constraint(equalTo: containerView.topAnchor),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),

            selectionView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 1),
            selectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -1),
            selectionView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 1.0 / CGFloat(tabs.count))
        ])
        
        selectionLeadingConstraint = selectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4)
        selectionLeadingConstraint.isActive = true

        updateUI(animated: false)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        if currentTabId != sender.tag {
            currentTabId = sender.tag
            onTabChanged?(tabs[sender.tag])
        }
    }

    
    // MARK: - Update UI
    
    private func updateUI(animated: Bool) {
        
        let offset = bounds.width / CGFloat(tabs.count)
        selectionLeadingConstraint.constant = CGFloat(currentTabId) * offset
        
        let changes = { self.layoutIfNeeded() }

        if animated {
            UIView.animate(withDuration: 0.25, delay: 0, options: [.curveEaseInOut], animations: changes)
        } else {
            changes()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI(animated: false)
    }
}
