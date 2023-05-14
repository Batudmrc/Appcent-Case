//
//  TracksViewController.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 9.05.2023.
//

import UIKit
import AVFoundation

class TracksViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var albumId: String?
    var albumName: String?
    var albumCover: String?
    var tracks: [TrackData] = []
    var audioPlayer: AVPlayer?
    var likedTrackIDs: [Int] = []
    let likedTrackIDsKey = "LikedTrackIDs"
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        if let savedData = UserDefaults.standard.data(forKey: "FetchedTrackData") {
            var savedTracks = (try? JSONDecoder().decode([TrackData].self, from: savedData)) ?? []
            
            // Remove duplicates from the array
            let uniqueTracks = Array(Set(savedTracks))
            
            // Save the updated array back to UserDefaults
            UserDefaults.standard.set(try? JSONEncoder().encode(uniqueTracks), forKey: "FetchedTrackData")
            
            // Print the saved tracks
            
            if let tabBarController = self.tabBarController,
               let tabBarViewControllers = tabBarController.viewControllers,
               let likedTracksNavController = tabBarViewControllers[1] as? UINavigationController,
               let likedTracksViewController = likedTracksNavController.viewControllers.first as? LikedTracksViewController {
                likedTracksViewController.tracks = uniqueTracks
            }
        } else {
            // No existing data found, save the fetched tracks directly
            UserDefaults.standard.set(try? JSONEncoder().encode(tracks), forKey: "FetchedTrackData")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = albumName
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.register(UINib(nibName: TracksCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)
        fetchData()
        loadLikedTrackIDs()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        audioPlayer?.pause()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.deezer.com/album/\(albumId!)/tracks") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "")")
                return
            }
            do {
                let track = try JSONDecoder().decode(Track.self, from: data)
                self?.tracks = track.data
                
                if let savedData = UserDefaults.standard.data(forKey: "FetchedTrackData") {
                    var savedTracks = (try? JSONDecoder().decode([TrackData].self, from: savedData)) ?? []
                    savedTracks.append(contentsOf: track.data)
                    let uniqueTracks = Array(Set(savedTracks))
                    UserDefaults.standard.set(try? JSONEncoder().encode(uniqueTracks), forKey: "FetchedTrackData")
                } else {
                    UserDefaults.standard.set(try? JSONEncoder().encode(track.data), forKey: "FetchedTrackData")
                }
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

    func loadLikedTrackIDs() {
        if let savedLikedTrackIDs = UserDefaults.standard.array(forKey: likedTrackIDsKey) as? [Int] {
            likedTrackIDs = savedLikedTrackIDs
        }
    }
    func loadTracks() {
        if let savedLikedTrackIDs = UserDefaults.standard.array(forKey: likedTrackIDsKey) as? [Int] {
            likedTrackIDs = savedLikedTrackIDs
        }
    }
    func saveLikedTrackIDs() {
        UserDefaults.standard.set(likedTrackIDs, forKey: likedTrackIDsKey)
    }
}

extension TracksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TracksCollectionViewCellDelegate {
    
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
        cell.updateLikedImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
        let track = tracks[indexPath.row]
        cell.isLiked = likedTrackIDs.contains(track.id)
        cell.updateLikedImage()
        cell.setup(track: track,imageUrl: albumCover)
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
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer?.play()
    }
    
}
