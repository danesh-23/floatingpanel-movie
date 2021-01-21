//
//  FloatingTable.swift
//  FloatingPanels
//
//  Created by Danesh Rajasolan on 2021-01-20.
//

import UIKit

class FloatingTable: UITableViewController {

    var weeklyMovies: [Movie] = []
    let networking = Networking()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networking.loadData(url: "https://api.themoviedb.org/3/discover/movie?api_key=e6592aa9d71db4ccf161b31f9a8c5c7a&language=en-US&region=US&sort_by=popularity.desc&include_adult=true&include_video=true&page=3&primary_release_year=2021&year=2021") { (movies) in
            let moreMonthMovies = self.networking.orderSearchResults(movies)
            self.weeklyMovies.append(contentsOf: moreMonthMovies)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyMovies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieListCell
        cell.titleMovie.font = .italicSystemFont(ofSize: 20)
        cell.titleMovie.textColor = .white
        cell.titleMovie.text = weeklyMovies[indexPath.row].title
        if self.weeklyMovies[indexPath.row].poster_path != nil {
            cell.imageMovie.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w342\(self.weeklyMovies[indexPath.row].poster_path!)"), placeholderImage: UIImage(named: "placeholder"))
        } else {
            cell.imageMovie.image = UIImage(named: "no-image-available")
        }
        cell.releaseDate.text = "Release Date : \(self.weeklyMovies[indexPath.row].release_date)"

        return cell
    }
}
