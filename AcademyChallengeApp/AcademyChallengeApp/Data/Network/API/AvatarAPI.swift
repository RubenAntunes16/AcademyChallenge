//
//  AvatarAPI.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import Foundation

enum AvatarAPI {
    case getAvatars
}

extension AvatarAPI: APIProtocol {
    
    var url: URL {
            URL(string: "https://api.github.com/users")!
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
