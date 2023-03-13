//
//  MatchDayListView.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 08/03/2023.
//

import SwiftUI

struct MatchesView: View {
    @StateObject private var matchesViewModel = MatchesViewModel()
    @State var showFavorites = false
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollViewReader { scrollViewReader in
                Toggle(isOn: $showFavorites) { Text("Show Favorite") }
                    .padding()
                    .frame(alignment: .top)
                    .onChange(of: showFavorites) { value in
                        // TODO: - filter by favorite
                        if value {
                            Task {
                                await matchesViewModel.showFavorite()
                            }
                        } else {
                            matchesViewModel.showAll()
                            // using asyncAfter 0.1 because the matches are not being rendered
                            Task {
                                let nextDay = await matchesViewModel.getNextDay()
                                withAnimation {
                                    scrollViewReader.scrollTo(nextDay, anchor: .top)
                                }
                            }
//                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
//                                withAnimation {
//                                    scrollViewReader.scrollTo("Today", anchor: .top)
//                                }
//                            }
                        }
                    }
                    ScrollView {
                        if matchesViewModel.loading {
                            LazyVStack {
                                GrayProgressView()
                                    .offset(x: 0, y: -100)
                                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height, alignment: .center)
                            }
                        } else {
                            LazyVStack(alignment: .center, spacing: 16, pinnedViews: [.sectionHeaders]) {
                                ForEach(matchesViewModel.filteredMatches) { group in
                                    Section(header: Text(group.id)) {
                                        ForEach(group.matches) { match in
                                            MatchView(match: match) {
                                                toggleFavorite(for: match)
                                            }
                                        }
                                    }
                                }
                            }
                            .onAppear {
                                Task {
                                    let nextDay = await matchesViewModel.getNextDay()
                                    withAnimation {
                                        scrollViewReader.scrollTo(nextDay, anchor: .top)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Matches"), displayMode: .inline)
            .background(Color(.systemGray6))
            .task {
                await matchesViewModel.loadMatches()
            }
        }
    }
    
    func toggleFavorite(for match: Match) {
        matchesViewModel.toggleFavorite(for: match)
    }
}

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
