//
//  Configuration.swift
//  FloatingPanel
//
//  Created by Danesh Rajasolan on 2021-01-19.
//

import Foundation

struct Configuration: Codable {
    let images: Images?
    let changeKeys: [String]?
}

struct Images: Codable {
    let baseURL: String?
    let secureBaseURL: String?
    let backdropSizes, logoSizes, posterSizes, profileSizes: [String]?
    let stillSizes: [String]?
}
