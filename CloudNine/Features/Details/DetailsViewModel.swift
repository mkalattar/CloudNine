//
//  DetailsViewModel.swift
//  CloudNine
//
//  Created by Mohamed Attar on 26/03/2025.
//

protocol DetailsViewModelProtocol {
    var product: ProductResponse {get set}
}

struct DetailsViewModel: DetailsViewModelProtocol {
    
    var product: ProductResponse
    
    init(product: ProductResponse) {
        self.product = product
    }
    
}
