//
//  MainView.swift
//  SearchingWithCombine
//
//  Created by YoonieMac on 3/24/26.
//

import SwiftUI

struct MainView: View {
    
    @State private var vm: MusicViewModel = .init()
    @State private var hasNoResult: Bool = false
    @State private var isSearching: Bool = false
    
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
                
                Button("취소") {
                    // cancel action
                    self.vm.searchText = ""
                    self.vm.searchTextColor = Color.black
                    self.hasNoResult = true
                    self.isSearching = false
                }
                .foregroundStyle(.red)
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal, 5)
                .padding(.vertical, 5)
                
            } //:HSTACK
            .font(.title2)
            .fontWeight(.semibold)
            .padding(20)
            
            VStack(alignment: .leading, spacing: 20) {
                if isSearching {
                    
                } else if hasNoResult {
                    
                } else {
                    
                }
                
            } //:VSTACK
            
            Spacer()
            
        } //:NAVIGATION
    }//:body
}

#Preview {
    MainView()
}
