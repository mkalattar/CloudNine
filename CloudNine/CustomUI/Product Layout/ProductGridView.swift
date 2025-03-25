//
//  ProductGridView.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import UIKit

class ProductGridView: UIView {
    
    // MARK: - Variables & UI Elements
    
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
    
    // MARK: - Private methods
    private func setupView() {
        backgroundColor = .systemBackground
        
        addSubview(productImageView)
        addSubview(titleLabel)
        addSubview(priceLabel)
        addSubview(ratingLabel)
        
        constraintLayout()
    }
    
    private func createImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .systemGray6
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .medium)
        label.numberOfLines = 2
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }
    
    private func createPriceLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
    
    private func constraintLayout() {
        
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
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 2),
            ratingLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 6),
            ratingLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -6),
        ])
    }
    
    // MARK: - Public Methods
    func setImage() {
        self.productImageView.image = UIImage(named: "testImg")
    }
    
    func set(title: String?) {
        self.titleLabel.text = title
    }
    
    func set(price: Double?) {
        guard let price = price else { return }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current // Uses the user's locale
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            self.priceLabel.text = formattedPrice
        } else {
            self.priceLabel.text = "\(price)"
        }
    }
    
    func set(rating: Double?, peopleCount: Int?) {
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .medium)
        
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(systemName: "star.fill", withConfiguration: imgConfig)?.withTintColor(.greenMint,
                                                                               renderingMode: .alwaysOriginal)
//        starAttachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        
        let starString = NSAttributedString(attachment: starAttachment)
        let ratingString = NSAttributedString(string: " \(rating ?? 0.0) ", attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        let peopleCountString = NSAttributedString(string: "(\(peopleCount ?? 0))", attributes: [
            .font: UIFont.systemFont(ofSize: 10, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        let fullRatingString = NSMutableAttributedString()
        fullRatingString.append(starString)
        fullRatingString.append(ratingString)
        fullRatingString.append(peopleCountString)
        
        ratingLabel.attributedText = fullRatingString
    }
}
