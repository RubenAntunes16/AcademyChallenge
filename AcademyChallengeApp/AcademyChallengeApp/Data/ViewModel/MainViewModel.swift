//
//  MainViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 26/10/2022.
//

import Foundation
import UIKit

//
import RxSwift

class MainViewModel {

    var application: Application

    var imageUrl: Wrapper<URL?> = Wrapper(nil)
    var searchText = Wrapper("")

    // This will 
    let backgroundScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "MainPageViewModel.backgroundScheduler")

    private var rxEmojiImageUrl: BehaviorSubject<URL?> = BehaviorSubject(value: nil)
    private var _rxEmojiImage: BehaviorSubject<UIImage?> = BehaviorSubject(value: nil)
    var rxEmojiImage: Observable<UIImage?> { _rxEmojiImage.asObservable() }

    let disposeBag = DisposeBag()
    var ongoingRequests: [String: Observable<UIImage?>] = [:]

    init(application: Application) {
        self.application = application
        searchText.bind { [weak self] text in
            if !text.isEmpty {
                self?.getAvatar()
            }
        }
    }

    func getRandomEmoji() {
        application.emojiService.getEmojisList({ [weak self] (result: Result<[Emoji], Error>) in
            switch result {
            case .success(let success):

                guard
                    let self = self,
                    let randomUrl = success.randomElement()?.urlImage else { return }
                DispatchQueue.main.async {
                    self.imageUrl.value = randomUrl
                }
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
