//
//  MatchesViewModel.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 09/03/2023.
//

import UIKit
import Combine
import Moya

class MatchesViewModel: ObservableObject {
    @Published var allMatches = [GroupMatch]()
    @Published var filteredMatches = [GroupMatch]()
    var localFilteredMatches = [GroupMatch]()
    var allDates = [Date]()
    @Published var loading = false
    @Published var cancellables = Set<AnyCancellable>()
    
    func toggleFavorite(for match: Match) {
        loading = true
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            self.updateAllMatches(match: match)
            self.updateLocalMatches(match: match)
        }
        loading = false
    }
    
    func updateAllMatches(match: Match) {
        for i in 0..<self.allMatches.count {
            var matches = self.allMatches[i].matches
            for j in 0..<matches.count where matches[j].id == match.id {
                matches[j].toggleFavorite()
                let group = GroupMatch(id: self.allMatches[i].id, matches: matches)
                DispatchQueue.main.async { [weak self] in
                    self?.allMatches[i] = group
                }
            }
        }
    }
    
    func updateLocalMatches(match: Match) {
        for i in 0..<self.localFilteredMatches.count {
            var matches = self.localFilteredMatches[i].matches
            for j in 0..<matches.count where matches[j].id == match.id {
                matches[j].toggleFavorite()
                let group = GroupMatch(id: self.allMatches[i].id, matches: matches)
                self.localFilteredMatches[i] = group
            }
        }
    }
    
    func showAll() {
        filteredMatches = allMatches
        localFilteredMatches = allMatches
    }
    
    func showFavorite() async {
        DispatchQueue.main.async { [weak self] in
            self?.loading = true
            self?.filteredMatches.removeAll()
            self?.localFilteredMatches.removeAll()
        }
        for i in 0..<allMatches.count {
            let group = GroupMatch(id: allMatches[i].id, matches: allMatches[i].matches.filter { $0.isFavorite ?? false })
            DispatchQueue.main.async { [weak self] in
                if !group.matches.isEmpty {
                    self?.filteredMatches.append(group)
                    self?.localFilteredMatches.append(group)
                }
            }
        }
        DispatchQueue.main.async { [weak self] in
            self?.loading = false
        }
    }
    
    func loadMatches() async {
        if Reachability.shared.connectionStatus() == .unknown || Reachability().connectionStatus() == .offline {
            fatalError("No internet connection")
        }
        DispatchQueue.main.async { [weak self] in
            self?.loading = true
            let provider = MoyaProvider<APIManager>()
            provider.requestPublisher(.matches)
                .map(Matches.self)
                .receive(on: DispatchQueue.main)
                .await({ response in
                    let group = await response.groupMatches()
                    DispatchQueue.main.async { [weak self] in
                        self?.loading = false
                        self?.allMatches = group.0
                        self?.filteredMatches = group.0
                        self?.allDates = group.1
                    }
                })
                .sink(receiveCompletion: { completion in
                    guard case let .failure(error) = completion else { return }
                    print(error.localizedDescription)
                }, receiveValue: { _ in }).store(in: &self!.cancellables)
        }
    }
    
    func getNextDay() async -> String {
        let allDates = allMatches.map { $0.id }
        let currentDate = Date()
        // Loop through the array of dates and find the next first date
        for dateString in allDates {
            // check if it's a custom date ("Today" or "Tomorrow"), return that custom date
            switch dateString {
            case CustomDays.yesterday.rawValue:
                // continue the loop while we don't want to scroll to "Yesterday"
                continue
            case CustomDays.today.rawValue:
                return CustomDays.today.rawValue
            case CustomDays.tomorrow.rawValue:
                return CustomDays.tomorrow.rawValue
            default:
                break
            }
            let date = dateString.toDateFromShortDate()
            if date >= currentDate {
                return date.toStringDate()
            }
        }
        // If no next first date was found, return empty string
        return ""
    }
}
