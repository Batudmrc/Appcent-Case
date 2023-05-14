//
//  LikedTracksViewController.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 10.05.2023.
//

import UIKit
import AVFoundation

class LikedTracksViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var albumId: String?
    var albumName: String?
    var albumCover: String?
    var tracks: [TrackData] = []
    var audioPlayer: AVPlayer?
    var likedTrackIDs: [Int] = []
    let likedTrackIDsKey = "LikedTrackIDs"
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadLikedTrackIDs()
        if let savedData = UserDefaults.standard.object(forKey: "FetchedTrackData") as? Data {
            if let allTracks = try? JSONDecoder().decode([TrackData].self, from: savedData) {
                tracks = allTracks.filter { likedTrackIDs.contains($0.id) }
            }
        }
        collectionView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer?.pause()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = albumName
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: TracksCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)
    }
    
    func loadLikedTrackIDs() {
        if let savedLikedTrackIDs = UserDefaults.standard.array(forKey: likedTrackIDsKey) as? [Int] {
            likedTrackIDs = savedLikedTrackIDs
        }
    }
    func saveLikedTrackIDs() {
        UserDefaults.standard.set(likedTrackIDs, forKey: likedTrackIDsKey)
    }
}
extension LikedTracksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TracksCollectionViewCellDelegate {
    
    func didTapLikeButton(for cell: TracksCollectionViewCell, track: TrackData) {
        guard let indexPath = collectionView.indexPath(for: cell) else {
            return
        }
        let trackID = track.id
        if let existingIndex = likedTrackIDs.firstIndex(of: trackID) {
            likedTrackIDs.remove(at: existingIndex)
        } else {
            likedTrackIDs.append(trackID)
        }
        saveLikedTrackIDs()
        loadLikedTrackIDs()
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
        let track = tracks[indexPath.row]
        cell.isLiked = likedTrackIDs.contains(track.id)
        cell.updateLikedImage()
        cell.setup(track: track,imageUrl: "https://api.deezer.com/album/\(String(describing: albumId))/image")
        cell.setImage()
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height / 6)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let track = tracks[indexPath.item]
        let previewURL = track.preview
        guard let url = URL(string: previewURL) else {
            return
        }
        let playerItem = AVPlayerItem(url: url)
        if let audioPlayer = audioPlayer {
                if audioPlayer.rate != 0 && audioPlayer.error == nil {
                    audioPlayer.pause()
                } else {
                    audioPlayer.replaceCurrentItem(with: playerItem)
                    audioPlayer.play()
                }
            } else {
                audioPlayer = AVPlayer(playerItem: playerItem)
                audioPlayer?.play()
            }
    }
}
