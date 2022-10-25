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
            var urlComponents = URLComponents(string: "\(Constants.baseURL)/users/apple/repos")

            urlComponents?.queryItems = [
                URLQueryItem(name: "per_page", value: String(perPage)),
                URLQueryItem(name: "page", value: String(page))
            ]
            
            guard let url = urlComponents?.url else { fatalError("[URLComponents] Cannot Convert to URL")}
            
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
