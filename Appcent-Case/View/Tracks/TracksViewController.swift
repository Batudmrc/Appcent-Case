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
    var tracks: [TrackData] = []
    var audioPlayer: AVPlayer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = albumName
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        // Do any additional setup after loading the view.
        
        collectionView.register(UINib(nibName: TracksCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: TracksCollectionViewCell.identifier)
        
        fetchData()
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
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

extension TracksViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TracksCollectionViewCell.identifier, for: indexPath) as! TracksCollectionViewCell
        let track = tracks[indexPath.row]
        print(tracks)
        cell.setup(track: track)
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
