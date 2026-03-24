//
//  Music.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import Foundation


// MARK: - Music
struct Music: Codable {
    let resultCount: Int
    let results: [Result]
}

// MARK: - Result
struct Result: Identifiable, Codable {
    let id = UUID()
    
    let artistName: String
    let trackName: String?

    enum CodingKeys: String, CodingKey {
        case artistName
        case trackName
    }
}


