//
//  DateExtensions.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 09/03/2023.
//

import Foundation

extension Date {
    func toStringTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        let dateString = formatter.string(from: self)
        return dateString
    }
    
    func toStringDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: self)
        return dateString
    }
}
