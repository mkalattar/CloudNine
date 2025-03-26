//
//  ProductGridCell.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import UIKit
import SkeletonView

class ProductGridCell: UICollectionViewCell {
    
    var productGridView = ProductView(layout: .grid)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productGridView)
        contentView.backgroundColor = .clear
        
        productGridView.frame = contentView.bounds
        productGridView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: ProductResponse, isShimmering: Bool) {
        if isShimmering {
            productGridView.showAnimatedGradientSkeleton()
        } else {
            productGridView.stopSkeletonAnimation()
            productGridView.hideSkeleton()
            
            productGridView.setImage(url: product.image)
            productGridView.set(title: product.title)
            productGridView.set(price: product.price)
            productGridView.set(rating: product.rating?.rate ?? 0.0, peopleCount: product.rating?.count ?? 0)
        }
    }
}
