//
//  GetEMojis.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 30/09/2022.
//

import Foundation
import CoreData
import UIKit

enum EmojiAPI {
    case getEmojis
}

extension EmojiAPI: APIProtocol {
    var url: URL {
        URL(string: "https://api.github.com/emojis")!
    }
    
    var method: Method{
        switch self{
        case .getEmojis:
            return .get
        }
    }
    
    var headers: [String: String]{
        ["Content-Type":"application/json"]
    }
}

struct EmojiAPICallResult: Decodable{
//    let emojis: [Emoji]
    var emojis: [Emoji] = []
    let persistence: EmojiPersistence = EmojiPersistence()
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let emojiAsDictionary = try container.decode([String: String].self)
        
        emojis = emojiAsDictionary.map({ (key: String, value: String) in
            persistence.persist(name: key, urlImage: value)
            return Emoji(name: key, urlImage: URL(string: value)!)
        })
    }
}

