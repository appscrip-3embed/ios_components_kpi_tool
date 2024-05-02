//
//  ImageCollectionViewCell.swift
//  DemoProject
//
//  Created by Appscrip 3Embed on 30/04/24.
//

import UIKit
import os.signpost
import SDWebImage

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PROPERTIES
    
    var signpostID: OSSignpostID?
    
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
        self.imageView.sd_cancelCurrentImageLoad()
        self.imageView.image = nil
        
        if let signpostID {
            os_signpost(.end, log: SignpostLog.networkingLog, name: "Background Image", signpostID: signpostID, "Status:%{public}@,Size:%llu", "Cancelled", 0)
        }
        
        signpostID = nil
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
        
        self.imageView.image = UIImage()
        
        guard let imageData,
              let imageUrls = imageData.urls,
              let urlString = imageUrls.full,
              let imageURL = URL(string: urlString)
        else {
            return
        }
        
        let address = unsafeBitCast(self, to: UInt.self)
        
        // Log a signpost to mark the start of the image download
        signpostID = OSSignpostID(log: SignpostLog.networkingLog)
        
        guard let signpostID else { return }
        
        os_signpost(.begin, log: SignpostLog.networkingLog, name: "Background Image", signpostID: signpostID, "Image name:%{public}@,Caller:%lu", urlString, address)
        
        self.imageView.sd_setImage(with: imageURL) { image, error, cache, url in
            
            guard let image else { return }
            
            let imageData = image.jpegData(compressionQuality: 1)!
            let imgData: NSData = NSData(data: imageData)
            let size = UInt(imgData.count)
            print("Image size in bytes: \(size)")
            
            os_signpost(.end, log: SignpostLog.networkingLog, name: "Background Image", signpostID: signpostID, "Status:%{public}@,Size:%llu", "Completed", size)
            
            self.signpostID = nil
        }
    }
    
}
