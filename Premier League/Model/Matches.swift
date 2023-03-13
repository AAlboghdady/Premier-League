//
//  Matches.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 09/03/2023.
//

import Foundation

struct Matches: Codable {
    var matches: [Match]
}

extension Matches {
    func groupMatches() async -> ([GroupMatch], [Date]) {
        var matchesByDate = [String: [Match]]()
        var groups = [GroupMatch]()
        var dates = [Date]()

        for match in matches {
            let dateKey = match.dateString
            
            if matchesByDate[dateKey] == nil {
                matchesByDate[dateKey] = [Match]()
            }
            
            matchesByDate[dateKey]?.append(match)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let sortedKeys: [String] = matchesByDate.keys.sorted(by: { dateFormatter.date(from: $0)! < dateFormatter.date(from: $1)! })
        for key in sortedKeys {
            groups.append(GroupMatch(id: getCustomDate(date: key), matches: matchesByDate[key]!))
            dates.append(key.toDateFromShortDate())
        }
        return (groups, dates)
    }
    
    func getCustomDate(date: String) -> String {
        let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: Date())?.toStringDate()
        let currentDay = Date().toStringDate()
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: Date())?.toStringDate()
        switch date {
        case previousDay:
            return CustomDays.yesterday.rawValue
        case currentDay:
            return CustomDays.today.rawValue
        case nextDay:
            return CustomDays.tomorrow.rawValue
        default:
            return date
        }
    }
}

enum CustomDays: String {
    case yesterday =  "Yesterday"
    case today = "Today"
    case tomorrow = "Tomorrow"
}
