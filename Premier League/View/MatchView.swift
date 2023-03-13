//
//  MatchView.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 11/03/2023.
//

import SwiftUI

struct MatchView: View {
    var match: Match
    @State var isFavorite = false
    let toggleFavorite: () -> Void

    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                TeamView(team: match.homeTeam)
                Spacer()
                TeamView(team: match.awayTeam)
            }
            .offset(x: 0, y: 8)
            .frame(alignment: .center)
            VStack(spacing: 8) {
                Button(action: {
                    isFavorite = !isFavorite
                    toggleFavorite()
                }) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                }
                Text(match.getScore())
                    .font(.subheadline)
            }
        }
        .frame(height: 30)
        .padding()
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .padding([.leading, .trailing], 16)
        .onAppear() {
            isFavorite = match.isFavorite ?? false
        }
    }
}
