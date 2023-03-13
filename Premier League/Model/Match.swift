//
//  Match.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 09/03/2023.
//

import Foundation

struct Match: Codable, Identifiable {
    let id: Int
    let utcDate: String
    let season: Season
    var status: String
    var homeTeam, awayTeam: Team
    var score: Score
    let matchday: Int
    // this variable is for saving to favorite
    // it's not coming from api
    var isFavorite: Bool? = false
}

extension Match {
    func getScore() -> String {
        if status == MatchStatus.finished.rawValue {
            let homeScore = score.fullTime.home ?? 0
            let awayScore = score.fullTime.away ?? 0
            let isHomeTeamIsWinner = score.winner == MatchWinner.homeWinner.rawValue
            let score = isHomeTeamIsWinner ? "\(homeScore) - \(awayScore)" : "\(awayScore) - \(homeScore)"
            return score
        } else {
            return timeString
        }
    }
    
    mutating func toggleFavorite() {
        isFavorite = !(isFavorite ?? false)
    }
}

extension Match {
    var timeString: String {
        get {
            let date = utcDate.toDate()
            let stringDate = date.toStringTime()
            return stringDate
        }
        set(value) {}
    }
    
    var dateString: String {
        let date = utcDate.toDate()
        let stringDate = date.toStringDate()
        return stringDate
    }
}

enum MatchStatus: String {
    case finished = "FINISHED"
    case scheduled = "SCHEDULED"
    case live = "LIVE"
    case inPlay = "IN_PLAY"
    case paused = "PAUSED"
    case postponed = "POSTPONED"
    case suspended = "SUSPENDED"
    case canceled = "CANCELED"
}

enum MatchWinner: String {
    case homeWinner = "HOME_TEAM"
    case awayWinner = "AWAY_TEAM"
    case draw = "DRAW"
}
