//
//  AvatarAPI.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import Foundation

enum AvatarAPI {
    // ASSOCIATED VALUES
    case getAvatars(String)
}

extension AvatarAPI: APIProtocol {
    var url: URL {
        switch self {
        case .getAvatars(let name):
            return URL(string: "https://api.github.com/users/\(name)")!
        }
    }
    
    var method: Method{
        switch self{
        case .getAvatars:
            return .get
        }
    }
    
    var headers: [String: String]{
        ["Content-Type":"application/json"]
    }
}
