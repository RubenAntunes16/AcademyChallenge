//
//  MainViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/10/2022.
//

import Foundation
import UIKit

class MainViewModel {

    var application: Application

    var imageUrl: Wrapper<URL?> = Wrapper(nil)
    var searchText = Wrapper("")

    init(application: Application) {
        self.application = application
        searchText.bind { [weak self] _ in
            self?.getAvatar()
        }
    }

    func getRandomEmoji() {
        application.emojiService.getEmojisList({ [weak self] (result: Result<[Emoji], Error>) in
            switch result {
            case .success(let success):

                guard
                    let self = self,
                    let randomUrl = success.randomElement()?.urlImage else { return }

                self.imageUrl.value = randomUrl

            case .failure(let failure):
                print("Failure: \(failure)")
                //                 self?.emojiImageView.image = UIImage(named: "noEmoji")
                self?.imageUrl.value = nil
            }

        })
    }

    private func getAvatar() {
        application.avatarService.getAvatar(searchText: searchText.value, { (result: Result<Avatar, Error>) in
            switch result {
            case .success(let success):

                let avatarUrl = success.avatarUrl

                self.imageUrl.value = avatarUrl

            case .failure(let failure):
                print("Failure to Get Avatar: \(failure)")
            }
        })
    }
}
