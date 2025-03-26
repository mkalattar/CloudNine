//
//  HomeViewController.swift
//  CloudNine
//
//  Created by Mohamed Attar on 24/03/2025.
//

import UIKit
import Combine
import SkeletonView

class HomeViewController: UIViewController {
    
    enum Section { case main }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ProductResponse>!
    
    var currentLayoutStyle: LayoutStyle {
        return viewModel?.getCurrentLayoutStyle() ?? .list
    }
    
    var isShimmering = false
    
    var viewModel: HomeViewModelProtocol?
    
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        self.title = "Home Page"
        self.view.backgroundColor = .bgGrey
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.setNaivgationControllerRightBtn()
        self.setupCollectionView()
        self.setupDataSource()
        self.subscribeToFetchProducts()
        self.subscribeToShimmering()
        
        viewModel?.viewDidLoad()
    }
    
    private func subscribeToShimmering() {
        viewModel?.isShimmeringPublisher.sink(receiveValue: { isShimmering in
            DispatchQueue.main.async {
                if isShimmering ?? false {
                    self.applySkeletonSource()
                } else {
                    self.isShimmering = false
                }
            }
        }).store(in: &cancellables)
    }
    
//    private func subscribeToErrorMsgs() {
//        viewModel?.errorMessagePublisher.sink(receiveValue: { errorMsg in
//            guard let errorMsg else { return }
//            DispatchQueue.main.async { [weak self] in
//                
//            }
//        })
//        .store(in: &cancellables)
//    }
    
    private func subscribeToFetchProducts() {
        
        viewModel?.productsPublisher.sink(receiveValue: { products in
            DispatchQueue.main.async { [weak self] in
                self?.applySnapshot(items: products ?? [])
            }
        })
        .store(in: &cancellables)
    }
    
    @objc
    func changeLayoutStyle() {
        viewModel?.changeLayoutStyle()
        
        self.setNaivgationControllerRightBtn()
        self.collectionView.collectionViewLayout = (currentLayoutStyle == .grid) ? createGridLayout() : createListLayout()
        self.collectionView.reloadData()
    }
    
    private func setNaivgationControllerRightBtn() {
        
        let gridImage = UIImage(named: "grid")?.withTintColor(.label)
        let listImage = UIImage(named: "list")?.withTintColor(.label)
        
        let button = UIButton()
        button.setImage( (currentLayoutStyle == .grid) ? listImage : gridImage, for: .normal)
        button.tintColor = .label
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(changeLayoutStyle), for: .touchUpInside)
        
        let barButton = UIBarButtonItem(customView: button)
        navigationItem.rightBarButtonItem = barButton
    }
}

// MARK: - CollectionView Setup
extension HomeViewController {
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: (currentLayoutStyle == .grid) ? createGridLayout() : createListLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        
        collectionView.register(ProductGridCell.self, forCellWithReuseIdentifier: String(describing: ProductGridCell.self))
        collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: String(describing: ProductListCell.self))
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func applySkeletonSource() {
        self.isShimmering = true
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductResponse>()
        snapshot.appendSections([.main])
        
        let placeholders = Array(repeating: ProductResponse(id: Int.random(in: 1...100), title: nil, price: nil, description: nil, category: nil, image: nil, rating: nil), count: 1)
        
        snapshot.appendItems(placeholders)
        
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.5),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(230)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            return section
        }
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { _, _ in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(1.0)
            )
            
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(130)
            )
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item, item])
            group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 8, trailing: 0)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16)
            
            return section
        }
    }
    
    private func setupDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ProductResponse>(collectionView: collectionView) { collectionView, indexPath, item in
                        
            if self.currentLayoutStyle == .grid {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductGridCell.self), for: indexPath) as! ProductGridCell
                cell.configure(with: item, isShimmering: self.isShimmering)
                
                return cell
            } else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ProductListCell.self), for: indexPath) as! ProductListCell
                cell.configure(with: item, isShimmering: self.isShimmering)
                
                return cell
            }
        }
    }
    
    private func applySnapshot(items: [ProductResponse]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductResponse>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        // Check if we're near the bottom and not already loading
        if offsetY > contentHeight - height - 100 {
            Task {
               await self.viewModel?.fetchProducts(incrementPagination: true)
            }
        }
    }
}
