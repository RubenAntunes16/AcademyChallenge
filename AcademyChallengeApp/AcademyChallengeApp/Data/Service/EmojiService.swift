//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 06/10/2022.
//

import Foundation

import RxSwift

protocol EmojiService {

    func getEmojisList() -> Single<[Emoji]>
}
