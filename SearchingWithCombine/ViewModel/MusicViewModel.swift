//
//  MusicViewModel.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import Foundation
import Combine
import SwiftUI
import SwiftData

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
    
    var modelContext: ModelContext? = nil
    
    var searchResults: Music? = nil
    var musics: [Result] = []
    var numberOfResults: Int = 0
    var errorMessage: String = ""
    var searchTextColor: Color = .black
    var hasNoResult: Bool = false
    var isSearching: Bool = false
    var searchText = "" {
        didSet {
            searchTextSubject.send(searchText)
            searchTextColor = .blue
            isSearching = true
        }
    }
    
    private let searchTextSubject = PassthroughSubject<String, Never>()
    
    private var cancellables: Set<AnyCancellable> = Set<AnyCancellable>()
    
    init() {
        
        searchTextSubject
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap { $0.isEmpty ? nil : URL(string: "https://itunes.apple.com/search?term=\($0)&limit=10") }
            .map { url in
                URLSession.shared.dataTaskPublisher(for: url)
                    .subscribe(on: DispatchQueue.global(qos: .background))
                    .tryMap(self.handleResponse)
                    .mapError { $0 as? NetworkError ?? .invalidData }
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else {return}
                if case .failure(let error) = completion {
                    self.errorMessage = error.rawValue
                    self.searchTextColor = .black
                    self.isSearching = false
                    self.hasNoResult = true
                }
            } receiveValue: { [weak self] music in
                guard let self else {return}
                self.searchResults = music
                self.musics = music.results
                self.numberOfResults = music.resultCount
                self.searchTextColor = .black
                self.isSearching = false
                self.hasNoResult = (music.resultCount != 0)
                
                guard let modelContext = self.modelContext else {return}
                self.musics.forEach {
                    let track = Track(artist: $0.artistName, trackName: $0.trackName)
                    modelContext.insert(track)
                }
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
