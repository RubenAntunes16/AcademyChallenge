//
//  AppleReposAPI.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 17/10/2022.
//

import Foundation

enum AppleReposAPI {
    case getAppleRepos
}

extension AppleReposAPI: APIProtocol {
    var url: URL {
        get {
            URL(string: "https://api.github.com/users/apple/repos")!
        }
        set {
            
        }
    }
    
    var method: Method{
        switch self{
        case .getAppleRepos:
            return .get
        }
    }
    
    var headers: [String: String]{
        ["Content-Type":"application/json"]
    }
}
