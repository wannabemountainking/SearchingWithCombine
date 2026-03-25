//
//  MainView.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var vm: MusicViewModel = .init()
    @State private var searchText: String = ""
    @State private var hasNoResult: Bool = false
    @State private var isSearching: Bool = false
    
    var body: some View {
        NavigationStack {

            
            VStack(alignment: .leading, spacing: 20) {
                if isSearching {
                    
                } else if hasNoResult {
                    
                } else {
                    
                }
                
            }
            Spacer()
        }
    }
}

#Preview {
    MainView()
}
