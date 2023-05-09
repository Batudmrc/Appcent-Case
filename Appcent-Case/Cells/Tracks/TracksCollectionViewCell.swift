//
//  TracksCollectionViewCell.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 9.05.2023.
//

import UIKit

class TracksCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var likedImage: UIImageView!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var trackTitle: UILabel!
    @IBOutlet weak var trackImage: UIImageView!
    
    
    static let identifier = String(describing: TracksCollectionViewCell.self)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup(track: TrackData) {
        self.durationLabel.text = String(track.duration)
        self.trackTitle.text = track.title
        }

}
