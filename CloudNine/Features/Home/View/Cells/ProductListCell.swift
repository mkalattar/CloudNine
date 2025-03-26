//
//  ProductListCell.swift
//  CloudNine
//
//  Created by Mohamed Attar on 25/03/2025.
//

import UIKit
import SkeletonView

class ProductListCell: UICollectionViewCell {
    
    var productListView = ProductView(layout: .list)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(productListView)
        contentView.backgroundColor = .clear
        
        productListView.frame = contentView.bounds
        productListView.isSkeletonable = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with product: ProductResponse, isShimmering: Bool) {
        if isShimmering {
            productListView.showAnimatedGradientSkeleton()
        } else {
            productListView.stopSkeletonAnimation()
            
            productListView.setImage(url: product.image)
            productListView.set(title: product.title)
            productListView.set(price: product.price)
            productListView.set(rating: product.rating?.rate ?? 0.0, peopleCount: product.rating?.count ?? 0)
        }
    }
}
