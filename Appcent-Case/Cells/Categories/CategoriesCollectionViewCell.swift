//
//  CategoriesCollectionViewCell.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//

import UIKit

class CategoriesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var categoryLabel: UILabel!
    
    static let identifier = String(describing: CategoriesCollectionViewCell.self)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(category: Datum) {
        self.categoryLabel.text = category.name
        if let imageUrl = URL(string: category.picture) {
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
struct CategoryList {
    var image: String?
    var name: String?
}
