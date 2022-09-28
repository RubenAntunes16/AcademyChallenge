//
//  Emoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/09/2022.
//

import Foundation
import UIKit

struct Emoji: CustomDebugStringConvertible {
    
    var name: String
    var urlImage: String
    
    var debugDescription: String {
        "\(name) \(urlImage)"
    }
}

protocol Network {
    func downloadImage(from url: URL, emojiImageView: UIImageView)
}


