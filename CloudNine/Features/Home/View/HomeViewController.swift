//
//  HomeViewController.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

import UIKit

class HomeViewController: UIViewController {
    
    let gridImage = UIImage(named: "grid")
    let listImage = UIImage(named: "list")
    
    var layoutStyle = LayoutState.grid
        
    override func viewDidLoad() {
        self.title = "Home Page"
        self.view.backgroundColor = .bgGrey
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setNaivgationControllerRightBtn()
    }
    
    @objc
    func changeLayoutStyle() {
        if layoutStyle == .grid {
            layoutStyle = .list
        } else {
            layoutStyle = .grid
        }
        
        self.setNaivgationControllerRightBtn()
    }
    
    private func setNaivgationControllerRightBtn() {
        
        // TODO: Check for its state in UserDefaults.
        
        let button = UIButton()
        button.setImage(layoutStyle == .grid ? listImage : gridImage, for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(changeLayoutStyle), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
}
