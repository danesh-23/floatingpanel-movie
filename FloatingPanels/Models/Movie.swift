//
//  Movie.swift
//  FloatingPanel
//
//  Created by Danesh Rajasolan on 2021-01-19.
//

import Foundation

struct Movies: Codable {
    let results: [Movie]
}

struct Movie: Codable, Identifiable {
    let id: Int
    let adult: Bool
    let backdrop_path: String?
    let genre_ids: [Int]
    let original_language: String
    let original_title: String
    let overview: String
    let popularity: Double
    let poster_path: String?
    let release_date: String
    let title: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
}
