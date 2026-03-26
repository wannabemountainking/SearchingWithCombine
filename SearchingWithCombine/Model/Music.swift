//
//  Music.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import Foundation
import SwiftData

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

@Model
final class Track {
    
    var artist: String
    var trackName: String?
    
    init(artist: String, trackName: String? = nil) {
        self.artist = artist
        self.trackName = trackName
    }
}

@MainActor
extension Track {
    static var previewContainer: ModelContainer {
        let container: ModelContainer
        
        do {
            container = try ModelContainer(for: Track.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        } catch {
            fatalError("Error on InMemoryOnlyData Setting: \(error)")
        }
        
        let mockTracks = [
            Track(artist: "IU", trackName: "someday"),
            Track(artist: "Guys")
        ]
        
        for mockTrack in mockTracks {
            container.mainContext.insert(mockTrack)
        }
        
        try? container.mainContext.save()
        return container
    }
}


