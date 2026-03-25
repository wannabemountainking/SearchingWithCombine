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

enum NetworkError: String, Error {
    case invalidURL = "URL 문제"
    case invalidResponse = "서버 응답 문제"
    case invalidData = "데이터 파싱 문제"
}



@Observable
final class MusicViewModel {
    
    var searchResults: Music? = nil
    var musics: [Result] = []
    var numberOfResults: Int = 0
    var errorMessage: String = ""
    
    var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
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
            .tryMap(handleResponse)
            .mapError { error in
                return error as? NetworkError ?? .invalidData
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                switch completion {
                case .failure(let error):
                    switch error {
                    case .invalidURL: self.errorMessage = error.rawValue
                    case .invalidResponse: self.errorMessage = error.rawValue
                    case .invalidData: self.errorMessage = error.rawValue
                    }
                case .finished:
                    break
                }
            } receiveValue: { music in
                self.searchResults = music
                self.musics = music.results
                self.numberOfResults = music.resultCount
            }
            .store(in: &cancellables)
    }
    
    func handleResponse(output: URLSession.DataTaskPublisher.Output) throws -> Music {
        let (data, response) = output
        guard let response = response as? HTTPURLResponse,
              response.statusCode >= 200 && response.statusCode < 300 else {
            throw NetworkError.invalidResponse
        }
        do {
            let music = try JSONDecoder().decode(Music.self, from: data)
            return music
        } catch {
            throw NetworkError.invalidData
        }
    }
}
