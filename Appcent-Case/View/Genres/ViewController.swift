//
//  ViewController.swift
//  Appcent-Case
//
//  Created by Batuhan Demircioğlu on 8.05.2023.
//

import UIKit

class ViewController: UIViewController {
    var genreName: String?
    var categories: [Datum] = []
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        
        collectionView.register(UINib(nibName: CategoriesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: CategoriesCollectionViewCell.identifier)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 1
        collectionView.collectionViewLayout = layout
        
        fetchData()
    }
    
    
    func fetchData() {
        guard let url = URL(string: "https://api.deezer.com/genre") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "")")
                return
            }
            
            do {
                let genre = try JSONDecoder().decode(Genre.self, from: data)
                self?.categories = genre.data
                
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
        let category = categories[indexPath.item]
        let genreId = category.id
        genreName = category.name
        
        guard URL(string: "https://api.deezer.com/genre/\(genreId)/artists") != nil else {
            return
        }
        
        performSegue(withIdentifier: "artistVC", sender: genreId)
        
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

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoriesCollectionViewCell.identifier, for: indexPath) as! CategoriesCollectionViewCell
        let category = categories[indexPath.row]
        cell.setup(category: category)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let collectionViewWidth = collectionView.bounds.width
            let cellWidth = collectionViewWidth / 2 // Two cells per line
            let cellHeight: CGFloat = 180 // Specify the desired height

            return CGSize(width: cellWidth, height: cellHeight)
        }
}


