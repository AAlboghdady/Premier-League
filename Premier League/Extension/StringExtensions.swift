//
//  StringExtensions.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 10/03/2023.
//

import Foundation

extension String {
    func toDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateFromString : Date = dateFormatter.date(from: self)!
        return dateFromString
    }
    
    func toDateFromShortDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateFromString : Date = dateFormatter.date(from: self)!
        return dateFromString
    }
}
