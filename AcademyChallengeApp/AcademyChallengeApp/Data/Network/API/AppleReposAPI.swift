//
//  AppleReposAPI.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 17/10/2022.
//

import Foundation

enum AppleReposAPI {
    case getAppleRepos(perPage: Int,page: Int)
}

extension AppleReposAPI: APIProtocol {
    var url: URL {
        switch self {
        case .getAppleRepos(let perPage, let page):
            var urlComponents = URLComponents(string: "https://api.github.com/users/apple/repos")

            urlComponents?.queryItems = [
                URLQueryItem(name: "per_page", value: String(perPage)),
                URLQueryItem(name: "page", value: String(page))
            ]
            
            guard let url = urlComponents?.url else {
                print("ERROR TO CONVERT TO URL")
                return URL(string: "")!
            }
            
            return url
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
