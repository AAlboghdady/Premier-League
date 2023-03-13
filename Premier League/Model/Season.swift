//
//  Season.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 09/03/2023.
//

import Foundation

struct Season: Codable {
    let id: Int
    let startDate, endDate: String
    let currentMatchday: Int
}
