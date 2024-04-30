//
//  ImageCollectionViewCell.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import UIKit
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let progressLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .black
        label.textColor = .white
        label.font = .systemFont(ofSize: 14, weight: .black)
        return label
    }()
    
    // MARK: MAIN -
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }
    
    // MARK: FUNCTIONS -
    
    func setUpViews(){
        addSubview(imageView)
        addSubview(progressLabel)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            progressLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            progressLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func loadImage(imageData: ImageResponseModel?) {
        
        self.imageView.image = nil
        
        guard let imageData,
              let imageUrls = imageData.urls,
              let urlString = imageUrls.small,
              let imageURL = URL(string: urlString)
        else {
            return
        }
        
        // Log a signpost to mark the start of the image download
        let signpostID = SignpostLog.startSignPost(name: "ImageDownload", "%@", imageURL.absoluteString)
        
        let progressBlock: SDWebImageDownloaderProgressBlock = { (receivedSize, expectedSize, url) in
            
            let progress = Float(receivedSize) / Float(expectedSize)
            
            // Log a signpost to track the image download progress
//            SignpostLog.eventSignPost(name: "ImageDownloadProgress", signpostID: signpostID, "%@: %.1f%%", imageURL.absoluteString, progress * 100)
            
            DispatchQueue.main.async {
                self.progressLabel.text = "progress: \(progress * 100)%"
            }
            
        }
        
        SDWebImageDownloader.shared.downloadImage(with: imageURL, options: [], progress: progressBlock) { (image, data, error, finished) in
            
            SignpostLog.endSignPost(name: "ImageDownloaded", signpostID: signpostID, "%@", imageURL.absoluteString)
            
            if let error = error {
                // Handle the error
                CustomLogger.log(.error, "\(error.localizedDescription)")
                return
            }
            
            // Check if the download is finished
            if finished, let image = image {
                self.imageView.image = image
            }
        }
    }
    
}
