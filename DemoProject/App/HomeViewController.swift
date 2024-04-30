//
//  HomeViewController.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import UIKit

class HomeViewController: UIViewController {

    // MARK: - PROPERTIES
    let viewModel = HomeViewModel()
    
    lazy var imageCollection: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        collectionView.setCollectionViewLayout(layout, animated: true)
        
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    // MARK: MAIN -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        setUpConstraints()
        loadData()
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        view.backgroundColor = .black
        view.addSubview(imageCollection)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            imageCollection.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageCollection.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageCollection.topAnchor.constraint(equalTo: view.topAnchor),
            imageCollection.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func loadData(){
        
        Task {
            do {
                try await viewModel.fetchImages()
                // reload the collection
                self.imageCollection.reloadData()
            } catch {
                // Handle errors
                CustomLogger.log(.error, "\(error.localizedDescription)")
            }
        }
        
    }

}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.imageResponseData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.loadImage(imageData: viewModel.imageResponseData[indexPath.row])
        cell.imageView.backgroundColor = viewModel.generateRandomColor()
        
        // pagination
        if viewModel.imageResponseData.count.isMultiple(of: viewModel.pageSize) {
            // for last element load again
            if indexPath.row == viewModel.imageResponseData.count - 1 {
                loadData()
            }
        }
        
        return  cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let estimatedWidth = UIScreen.main.bounds.width
//        let imageWidth = viewModel.imageResponseData[indexPath.row].width ?? 0
//        let imageHeight = viewModel.imageResponseData[indexPath.row].height ?? 0
//        let estimatedH = estimatedWidth * (imageHeight/imageWidth)
//        return CGSize(width: estimatedWidth, height: estimatedH)
        
        return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
    }
    
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
}
