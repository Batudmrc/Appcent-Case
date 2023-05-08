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
    
    var artists: [Datum] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = genreName
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: CategoriesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        
        fetchData()
        print(genreId!)
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
                let genre = try JSONDecoder().decode(Genre.self, from: data)
                self?.artists = genre.data
                
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
        //genreName = category.name
        
        guard URL(string: "https://api.deezer.com/genre/\(genreId)/artists") != nil else {
            return
        }
        performSegue(withIdentifier: "albumsVC", sender: genreId)

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "artistVC" {
            if let genreId = sender as? Int, let destinationVC = segue.destination as? ArtistViewController {
                // Pass the genre ID to the destination view controller
                destinationVC.genreId = genreId
                destinationVC.genreName = genreName
            }
        }
    }
}

extension ArtistViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
        let artist = artists[indexPath.row]
        cell.setup(category: artist)
        return cell
    }
    
    
}
