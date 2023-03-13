//
//  TeamView.swift
//  Premier League
//
//  Created by Abdurrahman Alboghdady on 12/03/2023.
//

import SwiftUI

struct TeamView: View {
    let team: Team
    
    var body: some View {
        Text(team.shortName)
//            .font(.subheadline)
    }
}
