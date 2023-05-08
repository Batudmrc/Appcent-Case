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
    func setup(album: AlbumData) {
        self.albumName.text = album.title
        if let imageUrl = URL(string: album.cover) {
            let task = URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard let data = data, error == nil else {
                    print("Error downloading image: \(error?.localizedDescription ?? "")")
                    return
                }
                DispatchQueue.main.async {
                    if let image = UIImage(data: data) {
                        self.imageView.image = image
                    }
                }
            }
            task.resume()
        }
    }
}

struct AlbumList {
    var image: String?
    var name: String?
    var date: String?
}
