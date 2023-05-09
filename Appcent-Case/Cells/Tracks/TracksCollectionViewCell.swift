//
//  TracksCollectionViewCell.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 9.05.2023.
//

import UIKit

class TracksCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
