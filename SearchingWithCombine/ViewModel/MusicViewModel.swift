//
//  MusicViewModel.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import Foundation
import Combine

/*
 **API**: iTunes Search API — `https://itunes.apple.com/search?term={query}&limit=10`
 */

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}



@Observable
final class MusicViewModel {
    
    var searchResults: Music?
    var musics: [Result] = []
    
    func fetchResults(searchText: String) throws {
        let endPoint = "https://itunes.apple.com/search?term=\(searchText)&limit=10"
        guard let url = URL(string: endPoint) else {
            throw NetworkError.invalidURL
        }
        
        loadMusicData(url: url)
    }
    
    
    func loadMusicData(url: URL) {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            
        
    }
    
    func handleResponse(data: Data?, response: URLResponse?) -> Music? {
        guard let data,
              let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {return nil}
    }
}
