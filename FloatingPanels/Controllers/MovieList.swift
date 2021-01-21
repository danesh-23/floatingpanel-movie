//
//  MovieList.swift
//  FloatingPanel
//
//  Created by Danesh Rajasolan on 2021-01-19.
//

import UIKit
import SDWebImage
import FirebaseUI

class MovieList: UITableViewController {
    
    var movies: [Movie] = []
    let firebaseHandler = FirebaseHandler()
    var favorited: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking().loadData(url: "https://api.themoviedb.org/3/discover/movie?api_key=e6592aa9d71db4ccf161b31f9a8c5c7a&language=en-US&region=US&sort_by=popularity.desc&include_adult=true&include_video=true&page=3&primary_release_year=2021&year=2021") { (movies) in
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movies)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        firebaseHandler.getTextFieldData { (datas) in
            self.favorited = datas[3] as? String ?? ""
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieListCell
        cell.titleMovie.font = .italicSystemFont(ofSize: 20)
        cell.titleMovie.textColor = .white
        cell.titleMovie.text = self.movies[indexPath.row].title
        if self.movies[indexPath.row].poster_path != nil {
            cell.imageMovie.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w342\(self.movies[indexPath.row].poster_path!)"), placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.imageMovie.image = UIImage(named: "no-image-available")
        }
        cell.releaseDate.text = "Release Date : \(self.movies[indexPath.row].release_date)"
        return cell
    }
   
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var action: UIContextualAction!
   
        if self.favorited.contains(self.movies[indexPath.row].title) {
            action = UIContextualAction(style: .normal,
                                            title: "Unfavorite") { [weak self] (action, view, completionHandler) in
                self?.favoriteMovie(movie: (self?.movies[indexPath.row])!, adding: false)
                self?.favorited = (self?.favorited.replacingOccurrences(of: ("\n\(self!.movies[indexPath.row].title)"), with: ""))!
                completionHandler(true)
            }
        } else {
            action = UIContextualAction(style: .normal,
                                            title: "Favorite") { [weak self] (action, view, completionHandler) in
                self?.favoriteMovie(movie: (self?.movies[indexPath.row])!, adding: true)
                self?.favorited.append("\n\(self!.movies[indexPath.row])")

                completionHandler(true)
            }
        }
        
        action.backgroundColor = .systemBlue
        return UISwipeActionsConfiguration(actions: [action])
    }

    private func favoriteMovie(movie: Movie, adding: Bool) {
        firebaseHandler.addFavoritedMovies(string: movie.title, add: adding)
    }
}
