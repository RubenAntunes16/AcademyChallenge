//
//  Emoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/09/2022.
//

import Foundation

struct Emoji {
    
    var name: String
    var urlImage: String
    
}

extension Emoji{
    var emojiDecoder : [EmojiData]{
        return[
            ("name",name),
            ("url",urlImage)
        ]
        
    }
}

typealias EmojiData = (name: String,url: String)


