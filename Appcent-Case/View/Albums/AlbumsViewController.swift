//
//  AlbumsViewController.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//

import UIKit

class AlbumsViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView: UIImageView!
    var artistName: String?
    var artistId: String?
    var albums: [AlbumData] = []
    var artistCoverBig: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = artistName
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        
        collectionView.register(UINib(nibName: AlbumsCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: AlbumsCollectionViewCell.identifier)
        
        fetchData()
        fetchCover()
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.deezer.com/artist/\(artistId!)/albums") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "")")
                return
            }
            do {
                
                let album = try JSONDecoder().decode(Album.self, from: data)
                self?.albums = album.data
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    
    func fetchCover() {
        guard let url = URL(string: "https://api.deezer.com/artist/\(artistId!)") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "")")
                return
            }
            do {
                let artist = try JSONDecoder().decode(Artist.self, from: data)
                if let imageUrl = URL(string: artist.pictureXl) {
                    let imageTask = URLSession.shared.dataTask(with: imageUrl) { (imageData, _, _) in
                        if let imageData = imageData, let image = UIImage(data: imageData) {
                            DispatchQueue.main.async {
                                self?.imageView.image = image
                            }
                        }
                    }
                    imageTask.resume()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }

}

extension AlbumsViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumsCollectionViewCell.identifier, for: indexPath) as! AlbumsCollectionViewCell
        let album = albums[indexPath.row]
        cell.setup(album: album)
        return cell
    }
}
