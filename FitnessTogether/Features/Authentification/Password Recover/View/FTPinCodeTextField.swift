//
//  FTPinCodeView.swift
//  FTPinCodeView
//
//  Created by Sergey Vasilich on 18.11.2025.
//

import UIKit


final class FTPinCodeTextField: UIView, UIKeyInput {
    
    struct DefaultConfig {
        static let digitsCount: Int = 5
        static let heightSize: Float = 54.0
        static let secureMode: Bool = false
    }

    var onCodeChanged: ((String) -> Void)?
    var onCodeFinich: ((String) -> Void)?
    
    private let stack = UIStackView()
    private var boxes: [UIView] = []
    private var labels: [UILabel] = []

    private(set) var code: String = "" {
        didSet {
            updateUI()
            onCodeChanged?(code)
        }
    }
    
    var isAllCharactersFilled: Bool {
        return code.count == digitsCount
    }

    private let digitsCount: Int = DefaultConfig.digitsCount
    private let secureMode: Bool = DefaultConfig.secureMode
    private let heightSize: Float = DefaultConfig.heightSize

    
    // MARK: - Init

    init(digits: Int = DefaultConfig.digitsCount,
         boxSize: Float = DefaultConfig.heightSize,
         secure: Bool = DefaultConfig.secureMode
    ) {
        super.init(frame: .zero)
        setupViews()
        becomeFirstResponder()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - UIResponder
    override var canBecomeFirstResponder: Bool {
        return true
    }

    // MARK: - UIKeyInput
    var hasText: Bool {
        return !code.isEmpty
    }

    func insertText(_ text: String) {
        guard code.count < digitsCount,
              text.rangeOfCharacter(from: .decimalDigits) != nil else { return }

        code.append(text)

        if code.count == digitsCount {
            onCodeFinich?(code)
        }
    }

    func deleteBackward() {
        guard !code.isEmpty else { return }
        code.removeLast()
    }

    
    // MARK: - Public API
    func clear() {
        code = ""
        resetError()
    }

    func showError() {
        animateError()
        boxes.forEach {
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.borderWidth = 1.5
        }
        
        labels.forEach {
            $0.font = DC.Font.subHeadline
        }
    }

    func resetError() {
        boxes.forEach {
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 1
        }
        
        labels.forEach {
            $0.font = DC.Font.subHeadline
        }
    }

    func setCode(_ newCode: String) {
        code = String(newCode.prefix(digitsCount))
    }

    // MARK: - Setup views
    private func setupViews() {
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .center
        stack.distribution = .equalCentering
        
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        for _ in 0..<digitsCount {
            let box = UIView()
            box.layer.cornerRadius = 8
            box.layer.borderWidth = 1
            box.layer.borderColor = UIColor.lightGray.cgColor

            let label = UILabel()
            label.font = DC.Font.subHeadline
            label.textAlignment = .center

            box.addSubview(label)
            
            label.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: box.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: box.centerYAnchor)
            ])
            
            box.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                box.widthAnchor.constraint(equalToConstant: CGFloat(heightSize)),
                box.heightAnchor.constraint(equalToConstant: CGFloat(heightSize))
            ])

            boxes.append(box)
            labels.append(label)
            stack.addArrangedSubview(box)

            box.translatesAutoresizingMaskIntoConstraints = false
            box.widthAnchor.constraint(equalTo: box.widthAnchor).isActive = true
        }
        
        highlightCurrentBox()
    }
    
    private func highlightCurrentBox() {
        for (index, label) in labels.enumerated() {
            let isActive = index == code.count

            label.font = isActive
                ? DC.Font.subHeadline
                : DC.Font.subHeadline
            
            let box = boxes[index]
            if isActive {
                label.text = "_"
            }
            
            if let text = label.text, !text.isEmpty {
                box.layer.borderColor = UIColor.orange.cgColor
                box.layer.borderWidth = 1.5
            }
            else {
                box.layer.borderColor = UIColor.gray.cgColor
                box.layer.borderWidth = 1
            }
        }
    }

    
    // MARK: - Update UI
    private func updateUI() {
        resetError()

        for i in 0..<digitsCount {
            if i < code.count {
                let index = code.index(code.startIndex, offsetBy: i)
                labels[i].text = secureMode ? "*" : String(code[index])
            } else {
                labels[i].text = ""
            }
        }
        
        highlightCurrentBox()
    }
    
    // MARK: - Error animations
    private func animateError() {
        let shake = CAKeyframeAnimation(keyPath: "transform.translation.x")
        shake.values = [-10, 10, -8, 8, -5, 5, 0]
        shake.duration = 0.35
        layer.add(shake, forKey: "shake")
    }
}
