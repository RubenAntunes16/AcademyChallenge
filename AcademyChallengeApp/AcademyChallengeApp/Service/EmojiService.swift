//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 06/10/2022.
//

import Foundation

protocol EmojiService {

    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void)
}

