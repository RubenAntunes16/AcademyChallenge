//
//  Avatar.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import Foundation

struct Avatar: Decodable {
    let name: String
    let id: Int
    let avatarUrl: URL

    enum CodingKeys: String, CodingKey {
        case name = "login"
        case id
        case avatarUrl = "avatar_url"
    }
}
