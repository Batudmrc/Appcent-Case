//
//  AlbumsCollectionViewCell.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//

import UIKit


class AlbumsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var releaseDate: UILabel!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    static let identifier = String(describing: AlbumsCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    static var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    func setup(album: AlbumData) {
        self.albumName.text = album.title
        self.releaseDate.text = album.releaseDate
        if let imageUrl = URL(string: album.cover) {
            // Check if the image is available in the cache
            if let cachedImage = AlbumsCollectionViewCell.imageCache.object(forKey: imageUrl.absoluteString as NSString) {
                self.imageView.image = cachedImage
            } else {
                let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    guard let data = data, error == nil else {
                        print("Error downloading image: \(error?.localizedDescription ?? "")")
                        return
                    }
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            // Cache the downloaded image
                            AlbumsCollectionViewCell.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString)
                            
                            self.imageView.image = image
                        }
                    }
                }
                task.resume()
            }
        }
    }
}
struct AlbumList {
    var image: String?
    var name: String?
    var date: String?
}
