//
//  TracksCollectionViewCell.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 9.05.2023.
//

import UIKit

protocol TracksCollectionViewCellDelegate: AnyObject {
    func didTapLikeButton(for cell: TracksCollectionViewCell, track: TrackData)
}

class TracksCollectionViewCell: UICollectionViewCell {
    
    weak var delegate: TracksCollectionViewCellDelegate?
    
    var track: TrackData?
    var isLiked: Bool = false
    
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    static let identifier = String(describing: TracksCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(likedImageTapped))
        likedImage.addGestureRecognizer(tapGesture)
        likedImage.isUserInteractionEnabled = true
        //updateLikedImage()
        // Initialization code
    }
    static var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        return cache
    }()
    
    func setup(track: TrackData, imageUrl: String?) {
        self.track = track
        let durationFormatted = formatDuration(track.duration)
        self.durationLabel.text = String(durationFormatted)
        self.trackTitle.text = track.title
        
        if let imageUrl = URL(string: imageUrl!) {
            // Check if the image is available in the cache
            if let cachedImage = TracksCollectionViewCell.imageCache.object(forKey: imageUrl.absoluteString as NSString) {
                self.trackImage.image = cachedImage
            } else {
                let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                    guard let data = data, error == nil else {
                        print("Error downloading image: \(error?.localizedDescription ?? "")")
                        return
                    }
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            // Cache the downloaded image
                            TracksCollectionViewCell.imageCache.setObject(image, forKey: imageUrl.absoluteString as NSString)
                            self.trackImage.image = image
                        }
                    }
                }
                task.resume()
            }
        }
    }
    func formatDuration(_ duration: Int) -> String {
        let minutes = duration / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func likedImageTapped() {
        isLiked.toggle()
        updateLikedImage()
        guard let track = track else {
            return
        }
        delegate?.didTapLikeButton(for: self, track: track)
    }
    func updateLikedImage() {
        let imageName = isLiked ? "heart.fill" : "heart"
        likedImage.image = UIImage(systemName: imageName)
        let color = isLiked ? UIColor.darkGray : UIColor.darkGray
        likedImage.tintColor = color
    }
}
