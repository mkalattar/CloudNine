//
//  DetailsViewController.swift
//  CloudNine
//
//  Created by Mohamed Attar on 26/03/2025.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var productImageView = UIImageView()
    var detailsView = UIView()
    var titleLabel = UILabel()
    var priceLabel = UILabel()
    var descLabel = UITextView()
    var ratingLabel = UILabel()
    var categoryLabel = UILabel()
    
    var titlePriceStackView = UIStackView()
    
    var viewModel: DetailsViewModelProtocol?
    var selectedProduct: ProductResponse? {
        return viewModel?.product
    }
    
    override func viewDidLoad() {
        self.title = "Details"
        self.view.backgroundColor = .bgGrey
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setupImageView()
        self.setupDetailsView()
        
        self.setupPriceLabel()
        self.setupTitleLabel()
        
        self.setupTitlePriceStackView()
        
        self.setupRatingLabel()
        self.setupCategoryLabel()
        self.setupDescTextView()
    }
    
    func setupImageView() {
        // setup
        self.view.addSubview(productImageView)
        self.productImageView.load(urlString: selectedProduct?.image ?? "")
        self.productImageView.contentMode = .scaleAspectFit
        self.productImageView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraint
        NSLayoutConstraint.activate([
            productImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            productImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            productImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            productImageView.heightAnchor.constraint(equalToConstant: self.view.bounds.height/3)
        ])
    }
    
    func setupDetailsView() {
        // setup
        self.view.addSubview(detailsView)
        self.detailsView.clipsToBounds = true
        self.detailsView.layer.cornerRadius = 30
        self.detailsView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.detailsView.backgroundColor = .systemBackground
        self.detailsView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        NSLayoutConstraint.activate([
            detailsView.topAnchor.constraint(equalTo: productImageView.bottomAnchor, constant: 16),
            detailsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            detailsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            detailsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
    }
    
    func setupTitlePriceStackView() {
        // setup
        self.detailsView.addSubview(titlePriceStackView)
        titlePriceStackView.axis = .horizontal
        titlePriceStackView.distribution = .fillProportionally
        titlePriceStackView.spacing = 16
        
        titlePriceStackView.addArrangedSubview(titleLabel)
        titlePriceStackView.addArrangedSubview(priceLabel)
        titlePriceStackView.translatesAutoresizingMaskIntoConstraints = false
        
        // constraints
        NSLayoutConstraint.activate([
            titlePriceStackView.topAnchor.constraint(equalTo: detailsView.topAnchor, constant: 16),
            titlePriceStackView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            titlePriceStackView.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16)
        ])
    }
    
    func setupTitleLabel() {
        // setup
        titleLabel.font = .systemFont(ofSize: 18, weight: .bold)
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .label
        titleLabel.textAlignment = .left
        titleLabel.text = selectedProduct?.title
    }
    
    func setupPriceLabel() {
        // setup
        priceLabel.font = .systemFont(ofSize: 18, weight: .bold)
        priceLabel.numberOfLines = 1
        priceLabel.textColor = .label
        priceLabel.textAlignment = .right
        priceLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        
        let price = selectedProduct?.price ?? 0.0
        
        if let formattedPrice = formatter.string(from: NSNumber(value: price)) {
            self.priceLabel.text = formattedPrice
        } else {
            self.priceLabel.text = "\(price)"
        }
    }
    
    func setupRatingLabel() {
        detailsView.addSubview(ratingLabel)
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let rating = selectedProduct?.rating?.rate ?? 0.0
        let peopleCount = selectedProduct?.rating?.count ?? 0
        
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 12, weight: .bold, scale: .medium)
        
        let starAttachment = NSTextAttachment()
        starAttachment.image = UIImage(systemName: "star.fill", withConfiguration: imgConfig)?.withTintColor(.greenMint, renderingMode: .alwaysOriginal)
        
        let starString = NSAttributedString(attachment: starAttachment)
        let ratingString = NSAttributedString(string: " \(rating) ", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        let peopleCountString = NSAttributedString(string: "(\(peopleCount))", attributes: [
            .font: UIFont.systemFont(ofSize: 12, weight: .medium),
            .foregroundColor: UIColor.label
        ])
        
        let fullRatingString = NSMutableAttributedString()
        fullRatingString.append(starString)
        fullRatingString.append(ratingString)
        fullRatingString.append(peopleCountString)
        
        ratingLabel.attributedText = fullRatingString
        
        NSLayoutConstraint.activate([
            ratingLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            ratingLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 8)
        ])
    }
    
    func setupCategoryLabel() {
        let bgView = UIView()
        bgView.addSubview(categoryLabel)
        
        detailsView.addSubview(bgView)
        
        categoryLabel.text = selectedProduct?.category?.uppercased()
        categoryLabel.textColor = .systemBackground
        categoryLabel.font = .systemFont(ofSize: 12, weight: .bold)
        
        bgView.backgroundColor = .systemGray
        bgView.layer.cornerRadius = 5
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bgView.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            bgView.centerYAnchor.constraint(equalTo: ratingLabel.centerYAnchor),
            
            categoryLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 4),
            categoryLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 4),
            categoryLabel.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -4),
            categoryLabel.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -4),
        ])
    }
    
    func setupDescTextView() {
        detailsView.addSubview(descLabel)
        descLabel.isEditable = false
        descLabel.isScrollEnabled = true
        descLabel.isSelectable = false
        descLabel.dataDetectorTypes = [.link, .phoneNumber] // just in case the desc of the item links to a website or a phoneNumber
        descLabel.text = selectedProduct?.description
        descLabel.font = .systemFont(ofSize: 12, weight: .regular)
        descLabel.textColor = .secondaryLabel
        descLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            descLabel.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 16),
            descLabel.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -16),
            descLabel.topAnchor.constraint(equalTo: ratingLabel.bottomAnchor, constant: 16),
            descLabel.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -16)
        ])
    }
}
