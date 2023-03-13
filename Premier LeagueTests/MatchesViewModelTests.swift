//
//  MatchesViewModelTests.swift
//  Premier LeagueTests
//
//  Created by Abdurrahman Alboghdady on 13/03/2023.
//

import XCTest
@testable import Premier_League

class MatchesViewModelTests: XCTestCase {
    
    var sut: MatchesViewModel!
    
    override func setUp() {
        super.setUp()
        sut = MatchesViewModel()
        // Given
        sut.allMatches = [GroupMatch(id: match.dateString, matches: [match, match]), GroupMatch(id: match.dateString, matches: [match])]
        sut.filteredMatches = sut.allMatches
        sut.localFilteredMatches = sut.allMatches
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testToggleFavorite() {
        sut.filteredMatches[0].matches[0].toggleFavorite()
        // Create an expectation
        let toggleExpectation = expectation(description: "toggleFavorite")
        
        // Call toggleFavorite and wait for the work to complete
        sut.toggleFavorite(for: sut.allMatches[0].matches[0])
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Assert that loading is true before the work starts
//            XCTAssertTrue(self.sut.loading)
            // Assert that the match's isFavorite property was toggled
            XCTAssertTrue(self.sut.allMatches[0].matches[0].isFavorite ?? false)
            XCTAssertTrue(self.sut.filteredMatches[0].matches[0].isFavorite ?? false)
            XCTAssertTrue(self.sut.localFilteredMatches[0].matches[0].isFavorite ?? false)
            // Fulfill the expectation
            toggleExpectation.fulfill()
        }
        
        // Wait for the expectation to be fulfilled
        wait(for: [toggleExpectation], timeout: 5)
    }
    
    func testShowAll() {
        // Given
        sut.allMatches = [GroupMatch(id: sut.allMatches[0].matches[0].dateString, matches: [match])]
        sut.filteredMatches = [GroupMatch(id: sut.allMatches[0].matches[0].dateString, matches: [match])]
        sut.localFilteredMatches = [GroupMatch(id: sut.allMatches[0].matches[0].dateString, matches: [match])]
        
        // When
        sut.showAll()
        
        // Then
        XCTAssertEqual(sut.filteredMatches.count, sut.allMatches.count)
        XCTAssertEqual(sut.localFilteredMatches.count, sut.allMatches.count)
    }
    
    func testShowFavorite() async {
        sut.allMatches[0].matches[0].toggleFavorite()
        sut.allMatches[1].matches[0].toggleFavorite()

        // Create an expectation
        let toggleExpectation = expectation(description: "ShowFavorite")
        
        await sut.showFavorite()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // Then
            XCTAssertEqual(self.sut.filteredMatches.count, 2)
            XCTAssertEqual(self.sut.localFilteredMatches.count, 2)
            XCTAssertEqual(self.sut.filteredMatches[0].matches.count, 1)
            XCTAssertEqual(self.sut.filteredMatches[1].matches.count, 1)
            XCTAssertFalse(self.sut.allMatches[0].matches[1].isFavorite ?? false)
            XCTAssertTrue(self.sut.filteredMatches[0].matches[0].isFavorite ?? false)
            XCTAssertTrue(self.sut.filteredMatches[1].matches[0].isFavorite ?? false)
            // Fulfill the expectation
            toggleExpectation.fulfill()
        }
        // Wait for the expectation to be fulfilled
        wait(for: [toggleExpectation], timeout: 5)
    }
    
    func testGetNextDayToday() async {
        sut.allMatches = [GroupMatch(id: CustomDays.today.rawValue, matches: [])]
        let nextDay = await sut.getNextDay()
        XCTAssertEqual(nextDay, CustomDays.today.rawValue)
    }
    
    func testGetNextDayTomorrow() async {
        sut.allMatches = [GroupMatch(id: CustomDays.tomorrow.rawValue, matches: [])]
        let nextDay = await sut.getNextDay()
        XCTAssertEqual(nextDay, CustomDays.tomorrow.rawValue)
    }
    
    func testGetNextDayCustomDate() async {
        let date = Date().addingTimeInterval(86400) // 86400 seconds in a day
        sut.allMatches = [GroupMatch(id: date.toStringDate(), matches: [])]
        let nextDay = await sut.getNextDay()
        XCTAssertEqual(nextDay, date.toStringDate())
    }
    
    func testGetNextDayEmpty() async {
        sut.allMatches = []
        let nextDay = await sut.getNextDay()
        XCTAssertEqual(nextDay, "")
    }
}

let season = Season(id: 1490, startDate: "2022-08-05", endDate: "2023-05-28", currentMatchday: 27)
let homeTeam = Team(id: 354, shortName: "Crystal Palace")
let awayTeam = Team(id: 57, shortName: "Arsenal")
var fullTime = FullTime(home: 0, away: 2)
var score = Score(winner: "AWAY_TEAM", fullTime: fullTime)
var match = Match(id: 416384, utcDate: "2022-08-05T19:00:00Z", season: season, status: "FINISHED", homeTeam: homeTeam, awayTeam: awayTeam, score: score, matchday: 1)
