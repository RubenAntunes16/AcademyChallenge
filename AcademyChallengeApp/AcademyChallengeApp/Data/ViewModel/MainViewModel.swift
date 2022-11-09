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
    let backgroundScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "MainViewModel.backgroundScheduler")

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

        rxEmojiImageUrl
            .debug("rxEmojiImageUrl")
            .flatMap({ [weak self] url -> Observable<UIImage?> in
                guard let self = self else { return Observable.never() }
                var observable = self.ongoingRequests[url?.absoluteString ?? ""]

                if observable == nil {
                    self.ongoingRequests[url?.absoluteString ?? ""] = self.dataOfUrl(url).share(replay: 1, scope: .forever)
                }

                guard let observable = self.ongoingRequests[url?.absoluteString ?? ""] else { return Observable.never() }

                return observable
            })
            .debug("rxEmojiImage")
            .subscribe(_rxEmojiImage)
            .disposed(by: disposeBag)

        application.emojiService.rxGetEmojisList()
            .do(onNext: { [weak self] emojis in
                guard
                    let self = self,
                    let emojis = emojis
                    else { return }
                let randomUrl = emojis.randomElement()?.urlImage
                self.rxEmojiImageUrl.onNext(randomUrl)
            })

        print("end init")
    }

    func dataOfUrl(_ url: URL?) -> Observable<UIImage?> {
        Observable<URL?>.never().startWith(url)
            .observe(on: backgroundScheduler)
            .flatMapLatest { url throws -> Observable<Data> in
                guard let url = url else { return Observable.just(Data()) }
                guard let data = try? Data(contentsOf: url) else { return Observable.just(Data()) }
                return Observable.just(data)
            }
            .map {
                UIImage(data: $0) ?? UIImage()
            }
            .observe(on: MainScheduler.instance)
            .debug("dataOfUrl")
    }

    func getRandomEmoji() {
        application.emojiService.getEmojisList({ [weak self] (result: Result<[Emoji], Error>) in
            switch result {
            case .success(let success):

                guard
                    let self = self,
                    let randomUrl = success.randomElement()?.urlImage else { return }
                self.rxEmojiImageUrl.onNext(randomUrl)
//                DispatchQueue.main.async {
//                    self.imageUrl.value = randomUrl
//                }
            case .failure(let failure):
                print("Failure: \(failure)")
                //                 self?.emojiImageView.image = UIImage(named: "noEmoji")
                self?.imageUrl.value = nil
            }

        })
    }

    func rxGetRandomEmoji() {
        application.emojiService.rxGetEmojisList()
            .do(onNext: { [weak self] emojis in
                guard
                    let self = self,
                    let emojis = emojis
                    else { return }
                let randomUrl = emojis.randomElement()?.urlImage
                self.rxEmojiImageUrl.onNext(randomUrl)
            })
    }

    private func getAvatar() {
        application.avatarService.getAvatar(searchText: searchText.value, { (result: Result<Avatar, Error>) in
            switch result {
            case .success(let success):

                let avatarUrl = success.avatarUrl

//                self.imageUrl.value = avatarUrl
                self.rxEmojiImageUrl.onNext(avatarUrl)

            case .failure(let failure):
                print("Failure to Get Avatar: \(failure)")
            }
        })
    }
}
