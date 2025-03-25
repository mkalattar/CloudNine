//
//  ErrorStateView.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//


import UIKit

class ErrorStateView: UIView {
    
    // MARK: - Variables & UI Elements
    private var retryAction: (() -> Void)?
    
    private lazy var contentStackView: UIStackView = {
        return createContectStackView()
    }()
    
    private lazy var descLabel: UILabel = {
        createDescLabel()
    }()
    
    private lazy var retryBtn: UIButton = {
        createRetryBtn()
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
        
        self.backgroundColor = .errorRed
        self.layer.cornerRadius = 16
        
        addSubview(contentStackView)
        
        constraintLayout()
    }
    
    private func createContectStackView() -> UIStackView {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(createIconImage())
        stackView.addArrangedSubview(createTitleLabel())
        stackView.addArrangedSubview(descLabel)
        stackView.addArrangedSubview(retryBtn)
        
        return stackView
    }
    
    private func createTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 1
        label.textColor = .label
        label.text = "Something wrong happened!"
        
        return label
    }
    
    private func createDescLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        
        return label
    }
    
    private func createIconImage() -> UIImageView {
        let imageView = UIImageView()
        let imgConfig = UIImage.SymbolConfiguration(pointSize: 24, weight: .bold, scale: .medium)
        
        imageView.image = UIImage(systemName: "exclamationmark.circle.fill", withConfiguration: imgConfig)?.withTintColor(.label, renderingMode: .alwaysOriginal)
        
        return imageView
    }
    
    private func createRetryBtn() -> UIButton {
        var configuration = UIButton.Configuration.gray()
        configuration.cornerStyle = .capsule
        configuration.baseForegroundColor = UIColor.systemRed
        configuration.buttonSize = .small
        configuration.title = "Retry"
        
        let button = UIButton(configuration: configuration, primaryAction: UIAction(handler: { [weak self] _ in
            self?.retryAction?()
        }))
        
        button.isHidden = true
        
        return button
    }
    
    private func constraintLayout() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            contentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            contentStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    // MARK: - Public methods
    func set(desc: String) {
        self.descLabel.text = desc
    }
    
    func set(btnAction: @escaping () -> Void) {
        self.retryAction = btnAction
        self.retryBtn.isHidden = false
    }
    
    func removeButton() {
        self.retryBtn.isHidden = true
    }
}
