//
//  AvatarAPI.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import Foundation

struct AvatarAPI: APIProtocol {
    
    var url: URL = URL(string: "https://api.github.com/users/")!
    
    var method: Method = .get
    
    var headers: [String: String]{
        ["Content-Type":"application/json"]
    }
}
