//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 06/10/2022.
//

import Foundation

import RxSwift

protocol EmojiService: ReactiveCompatible {

    func getEmojisList() -> Single<[Emoji]>
}

//extension Reactive where Base: EmojiService {
//    func getEmojisList() -> Single<[Emoji]> {
//        return base.getEmojisList()
//    }
//}
