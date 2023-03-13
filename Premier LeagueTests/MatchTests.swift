//
//  MatchTests.swift
//  Premier LeagueTests
//
//  Created by Abdurrahman Alboghdady on 14/03/2023.
//

import XCTest
@testable import Premier_League

final class MatchTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetScore() {
        // Test when match is finished and home team wins
        match.status = MatchStatus.finished.rawValue
        match.score = Score(winner: MatchWinner.homeWinner.rawValue, fullTime: FullTime(home: 2, away: 1))
        XCTAssertEqual(match.getScore(), "2 - 1")
        
        // Test when match is finished and away team wins
        match.score = Score(winner: MatchWinner.awayWinner.rawValue, fullTime: FullTime(home: 1, away: 2))
        XCTAssertEqual(match.getScore(), "2 - 1")
        
        // Test when match is finished and it's a draw
        match.score = Score(winner: MatchWinner.draw.rawValue, fullTime: FullTime(home: 1, away: 1))
        XCTAssertEqual(match.getScore(), "1 - 1")
        
        // Test when match is not finished
        match.status = MatchStatus.scheduled.rawValue
//        match.timeString = "07:00"
        XCTAssertEqual(match.getScore(), "09:00 PM")
    }
}
