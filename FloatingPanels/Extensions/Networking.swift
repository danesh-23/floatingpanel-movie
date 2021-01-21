//
//  Networking.swift
//  FloatingPanel
//
//  Created by Danesh Rajasolan on 2021-01-19.
//

import Foundation
import UIKit

struct Networking {
    
    func loadData(url: String, completion: @escaping ([Movie]) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                fatalError("error fetching data")
            } else {
                if let datas = data {
                    do {
                        let movies = try JSONDecoder().decode(Movies.self, from: datas)
                        completion(movies.results)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    func loadConfigData(url: String, completion: @escaping (Configuration) -> Void) {
        guard let url = URL(string: url) else { return }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                fatalError("error fetching data")
            } else {
                if let datas = data {
                    do {
                        let config = try JSONDecoder().decode(Configuration.self, from: datas)
                        completion(config)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }.resume()
    }
    
    func downloadImages(url: String, completion: @escaping (Data) -> Void) {
        URLSession.shared.dataTask(with: URL(string: url)!) { data, response, error in
            if error != nil {
                print(error?.localizedDescription)
            } else {
                completion(data!)
            }
        }.resume()
    }
    
    func createImageView(url: String, completion: @escaping (UIImage) -> Void) {
        downloadImages(url: url) { (data) in
            completion(UIImage(named: "movies")!)
        }
    }
    
    func orderSearchResults(_ movies: [Movie]) -> [Movie] {
        var monthMovies: [Movie] = []
        for movie in movies {
            let date = DateFormatter()
            date.dateFormat = "yyyy-MM-dd"
            let calendar = Calendar.current
            let components = calendar.dateComponents([.month], from: date.date(from: movie.release_date)!)
            let currentMonth = calendar.dateComponents([.month], from: Date())
            if components.month == currentMonth.month {
                monthMovies.append(movie)
            }
        }
        return monthMovies
    }
}
