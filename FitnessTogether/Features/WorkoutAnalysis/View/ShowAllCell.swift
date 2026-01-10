//
//  AnalysisExpandableCell.swift
//  FitnessTogether
//
//  Created by Sergey Vasilich on 14.12.2025.
//

import UIKit


final class ShowAllCell: UICollectionViewCell {
    
    static let reuseId = "ShowAllCell"

    private let label = UILabel()
    private let imageView = UIImageView()
    
    public var isCollapsed: Bool = false { didSet { animateImage() } }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        self.backgroundColor = .systemBackground
        setupLabel()
        setupImageView()
    }
    
    private func setupLabel() {
        addSubview(label)
        label.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
        }
        label.snp.contentCompressionResistanceVerticalPriority = 250
        label.snp.contentCompressionResistanceHorizontalPriority = 250
        label.snp.contentHuggingHorizontalPriority = 800
        
        label.text = "Показать всё"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = DC.Font.additionalInfo
    }
    
    private func setupImageView() {
        let imageConf = UIImage.SymbolConfiguration(weight: .semibold)
        let image = UIImage(systemName: "chevron.right")?.withConfiguration(imageConf)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray
        
        addSubview(imageView)
        imageView.snp.makeConstraints { [weak self] maker in
            guard let self else { return }
            maker.top.bottom.equalTo(label).inset(3).priority(.medium)
            maker.leading.equalTo(label.snp.trailing).offset(1)
            maker.width.equalTo(imageView.snp.height)
        }
    }
    
    
    //MARK: - Other
    private func animateImage() {
        let angle = isCollapsed ? 0 : CGFloat.pi/2
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.imageView.transform = CGAffineTransform(rotationAngle: angle)
        })
    }
    
    public override func draw(_ rect: CGRect) {
        super.draw(rect)
        let start = CGPoint(x: bounds.minX, y: bounds.minY)
        let end = CGPoint(x: bounds.maxX, y: bounds.minY)
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        path.lineWidth = 1
        UIColor.systemGray2.setStroke()
        path.stroke()
    }
}
