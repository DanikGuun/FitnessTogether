//
//  AnalysisExpandableCell.swift
//  FitnessTogether
//
//  Created by Sergey Vasilich on 14.12.2025.
//

import UIKit


public struct AnalysisItem: Hashable, Sendable {
    let id: String
    let title: String
    let date: String
    let sections: [Section]
    var isExpanded: Bool = false

    struct Section: Hashable {
        let title: String
        let text: String
    }
}

public protocol AnalysisItemDelegate {
    func onPressTainOnAnalyze(_ item: AnalysisItem)
}

final class AnalysisExpandableCell: UICollectionViewCell {

    static let reuseId = "AnalysisExpandableCell"

    private let container = UIView()
    private let headerStack = UIStackView()
    private let contentStack = UIStackView()

    private let titleLabel = UILabel()
    private let dateLabel = UILabel()
    
    private let space = UIView()
    
    var item: AnalysisItem? = nil
    var delegate: AnalysisItemDelegate? = nil

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        contentView.backgroundColor = .clear

        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 24
        container.layer.borderWidth = 1
        container.layer.borderColor = UIColor.systemOrange.cgColor
        container.backgroundColor = .white
        contentView.addSubview(container)

        titleLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        titleLabel.baselineAdjustment = .alignCenters
        titleLabel.numberOfLines = 1

        dateLabel.font = .systemFont(ofSize: 15, weight: .medium)
        dateLabel.textColor = .systemGray
        dateLabel.baselineAdjustment = .alignCenters
        dateLabel.numberOfLines = 1

        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.spacing = 12
        headerStack.addArrangedSubview(titleLabel)
        headerStack.addArrangedSubview(dateLabel)
        headerStack.translatesAutoresizingMaskIntoConstraints = false

        contentStack.axis = .vertical
        contentStack.spacing = 16
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(headerStack)
        container.addSubview(contentStack)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            headerStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),

            contentStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 40),
            contentStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 20),
            contentStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -20),
            contentStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20)
        ])
    }

    func configure(_ item: AnalysisItem) {
        self.item = item
        
        titleLabel.text = item.title
        dateLabel.text = item.date

        contentStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        space.frame = CGRect(x: 0, y: 0, width: 1, height: 20)
        contentStack.addArrangedSubview(space)

        if item.isExpanded {
            item.sections.forEach {
                contentStack.addArrangedSubview(makeSection($0))
            }
            let button = makeButton()
            contentStack.addArrangedSubview(makeButton())
        }

        contentStack.isHidden = !item.isExpanded
    }
    
    private func makeSection(_ section: AnalysisItem.Section) -> UIView {
        
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .semibold)
        title.text = section.title

        let text = UILabel()
        text.font = .systemFont(ofSize: 15)
        text.textColor = .darkGray
        text.numberOfLines = 0
        text.text = section.text

        let stack = UIStackView(arrangedSubviews: [title, text])
        stack.axis = .vertical
        stack.spacing = 6
        return stack
    }

    private func makeButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Тренировки в анализе", for: .normal)
        button.setTitleColor(.systemOrange, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemOrange.cgColor
        button.heightAnchor.constraint(equalToConstant: 44).isActive = true
        button.addAction(UIAction(handler: onTrainInAnalyze), for: .touchUpInside)
        return button
    }
    
    private func onTrainInAnalyze(_ action: UIAction?) {
        if let item = self.item {
            self.delegate?.onPressTainOnAnalyze(item)
        }
    }
}

