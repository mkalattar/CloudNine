//
//  ProductGridView.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import UIKit
import SkeletonView

class ProductView: UIView {
    
    // MARK: - Variables & UI Elements
    private var layout: LayoutStyle = .grid
    
    private lazy var productImageView: UIImageView = {
        return createImageView()
    }()
    
    private lazy var titleLabel: UILabel = {
        return createTitleLabel()
    }()
    
    private lazy var priceLabel: UILabel = {
        return createPriceLabel()
    }()
    
    private lazy var ratingLabel: UILabel = {
        return createRatingLabel()
    }()
    
    // MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    init(layout: LayoutStyle) {
        super.init(frame: .zero)
        self.layout = layout
        self.setupView()
    }
    
    // MARK: - Private methods
    private func setupView() {
        backgroundColor = .systemBackground
        layer.cornerRadius = 16
        
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(ratingLabel)
        
        switch layout {
        case .grid:
            constraintGridLayout()
        case .list:
            constraintListLayout()
        }
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .bgGrey
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isSkeletonable = true
        
        return imageView
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: layout == .grid ? 12 : 14, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isSkeletonable = true
        
        return label
    }
    
    private func createPriceLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: layout == .grid ? 12 : 14, weight: .bold)
        label.numberOfLines = 1
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func createRatingLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func constraintGridLayout() {
        NSLayoutConstraint.activate([
            // productImageView constraints
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 3),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 3),
            productImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -3),
            productImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.58),
            
            // titleLabel constraints
            titleLabel.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            // priceLabel constraints
            priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            priceLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            
            // rating constraints
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
        ])
    }
    
    private func constraintListLayout() {
        NSLayoutConstraint.activate([
            // productImageView constraints
            productImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            productImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            productImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            productImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // titleLabel constraints
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            
            // priceLabel constraints
            ratingLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            ratingLabel.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 6),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
            
            // rating constraints
            priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }
    
    // MARK: - Public Methods
    func setImage(url: String?) {
        self.productImageView.load(urlString: url ?? "")
    }
    
    func set(title: String?) {
        self.titleLabel.text = title
    }
    
    func set(price: Double?) {
        guard let price = price else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            self.priceLabel.text = formattedPrice
        } else {
            self.priceLabel.text = "\(price)"
        }
    }
    
    func set(rating: Double?, peopleCount: Int?) {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: layout == .grid ? 10 : 12, weight: .bold, scale: .medium)
        
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(systemName: "star.fill", withConfiguration: imgConfig)?.withTintColor(.greenMint, renderingMode: .alwaysOriginal)
        
        let starString = NSAttributedString(attachment: starAttachment)
        let ratingString = NSAttributedString(string: " \(rating ?? 0.0) ", attributes: [
            .font: UIFont.systemFont(ofSize: layout == .grid ? 10 : 12, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        let peopleCountString = NSAttributedString(string: "(\(peopleCount ?? 0))", attributes: [
            .font: UIFont.systemFont(ofSize: layout == .grid ? 10 : 12, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        let fullRatingString = NSMutableAttributedString()
        fullRatingString.append(starString)
        fullRatingString.append(ratingString)
        fullRatingString.append(peopleCountString)
        
        ratingLabel.attributedText = fullRatingString
    }
}

enum LayoutStyle {
    case grid, list
}
