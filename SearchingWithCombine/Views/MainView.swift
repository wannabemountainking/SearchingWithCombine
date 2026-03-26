//
//  MainView.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query var tracks: [Track]
    @State private var vm: MusicViewModel = .init()
    
    var body: some View {
        NavigationStack {
            HStack(spacing: 15) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.blue.opacity(0.7))
                
                TextField("검색어를 입력하세요", text: $vm.searchText)
                    .frame(height: 36)
                    .padding(.horizontal, 12)
                    .background(Color(uiColor: UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .textFieldStyle(.plain)
                if !vm.searchText.isEmpty {
                    Button("취소") {
                        // cancel action
                        self.vm.searchText = ""
                        self.vm.searchTextColor = Color.black
                        self.vm.hasNoResult = false
                        self.vm.isSearching = false
                    }
                    .foregroundStyle(.red)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 5)
                    .padding(.vertical, 5)
                }
                
            } //:HSTACK
            .font(.title2)
            .fontWeight(.semibold)
            .padding(.vertical, 50)
            .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 20) {
                if vm.isSearching {
                    VStack {
                        Text("* 0,5초 후 자동 검색")
                        List {
                            ForEach(vm.musics, id: \.id) { music in
                                HStack(spacing: 50) {
                                    Text(music.artistName)
                                    Text(music.trackName ?? "알 수 없음")
                                    if music.trackName != nil {
                                        Image(systemName: "music.note")
                                    } else {
                                        Text("아티스트")
                                    }
                                }
                                .font(.title3)
                            }
                        }
                    }
                } else if !vm.hasNoResult {
                    VStack(alignment: .leading, spacing: 30) {
                        Text("최근 검색")
                            .font(.title)
                            .fontWeight(.ultraLight)
                        List {
                            ForEach(tracks, id: \.id) { track in
                                HStack(spacing: 20) {
                                    Text("\(["🔴", "🟠", "🟢", "🟣", "🔵", "⚪️"].randomElement() ?? "🔴")")
                                    
                                    if track.trackName != nil {
                                        Text(track.trackName!)
                                        Spacer()
                                        Text("곡")
                                    } else {
                                        Text(track.artist)
                                        Spacer()
                                        Text("아티스트")
                                    }
                                }
                                .padding(20)
                            }
                        }
                    }
                } else {
                    ContentUnavailableView {
                        Text("\"\(vm.searchText)\"에 대한 검색 결과가 없습니다")
                        Text(vm.errorMessage)
                    }
                }
                
            } //:VSTACK
            .navigationTitle("검색")
            .navigationBarTitleDisplayMode(.large)
            
            Spacer()
            
        } //:NAVIGATION
        .onAppear {
            vm.modelContext = self.modelContext
        }
    }//:body
}

#Preview {
    MainView()
        .modelContainer(Track.previewContainer)
}
