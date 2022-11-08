//
//  EmojiViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/10/2022.
//

import Foundation

class EmojiViewModel {

    var emojiService: EmojiService?

    var emojisList: Wrapper<[Emoji]?> = Wrapper([])

    func getEmojisList() {
        emojiService?.getEmojisList({ [weak self] (result: Result<[Emoji], Error>) in
            switch result {
            case .success(var success):
                success.sort()
                self?.emojisList.value = success

            case .failure(let failure):
                print("[Emoji View Model] Failure: \(failure)")
            }

        })
    }
}
