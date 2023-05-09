//
//  ArtistViewController.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//

import UIKit

class ArtistViewController: UIViewController {
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    var genreId: Int?
    var genreName: String?
    var artistName: String?
    var artistId: String?
    var artistCoverBig: UIImage?
    
    var artists: [Datum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = genreName
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: CategoriesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        fetchData()
        // Do any additional setup after loading the view.
    }
    
    func fetchData() {
        guard let url = URL(string: "https://api.deezer.com/genre/\(genreId!)/artists") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "")")
                return
            }
            do {
                let artist = try JSONDecoder().decode(Genre.self, from: data)
                self?.artists = artist.data
                
                DispatchQueue.main.async {
                    self?.collectionView.reloadData()
                }
            } catch {
                print("Error decoding data: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let artist = artists[indexPath.item]
        let genreId = artist.id
        artistName = artist.name
        artistId = String(artist.id)
        
        guard URL(string: "https://api.deezer.com/genre/\(genreId)/artists") != nil else {
            return
        }
        performSegue(withIdentifier: "albumsVC", sender: genreId)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "albumsVC" {
            if let genreId = sender as? Int, let destinationVC = segue.destination as? AlbumsViewController {
                // Pass the genre ID to the destination view controller
                destinationVC.artistId = String(genreId)
                destinationVC.artistName = artistName
                destinationVC.artistCoverBig = artistCoverBig
            }
        }
    }
}

extension ArtistViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
        let artist = artists[indexPath.row]
        cell.setup(category: artist)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            let cellWidth = collectionViewWidth / 2 // Two cells per line
            let cellHeight: CGFloat = 180 // Specify the desired height

            return CGSize(width: cellWidth, height: cellHeight)
        }
}

