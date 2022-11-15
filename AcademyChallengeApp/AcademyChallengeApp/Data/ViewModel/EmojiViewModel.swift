//
//  EmojiViewModel.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 27/10/2022.
//

import Foundation
import UIKit
//
import RxSwift

class EmojiViewModel {

    var emojiService: EmojiService?

    var emojisList: Wrapper<[Emoji]?> = Wrapper([])

    let backgroundScheduler = SerialDispatchQueueScheduler(internalSerialQueueName: "MainViewModel.backgroundScheduler")

    var ongoingRequests: [String: Observable<UIImage>] = [:]

    private var _rxEmojiList: PublishSubject<[Emoji]?> = PublishSubject()
    // WE USE VARIBLE OF TYPE OBSERVALBLE, ONLY TO ACCESS OUTSIDE
    // WE CAN'T CALL onNext() FUNCTIONS
    var rxEmojiList: Observable<[Emoji]?> { _rxEmojiList.asObservable() }

    let disposeBag = DisposeBag()

//    init() {
//        _rxEmojiList
//            .
//            .disposed(by: disposeBag)
//    }

    func imageFromUrl(url: URL) -> Observable<UIImage> {
        Observable<UIImage>
            .deferred({ [weak self] in
                guard let self = self else { return Observable.never() }
                let observable = self.ongoingRequests[url.absoluteString]

                if observable == nil {
                    // shared removed because we only go get emoji once
                    self.ongoingRequests[url.absoluteString] = self.dataOfUrl(url)
                }

                guard let observable = self.ongoingRequests[url.absoluteString] else { return Observable.never() }

                return observable
            })
            .subscribe(on: MainScheduler.instance)
    }

    func dataOfUrl(_ url: URL?) -> Observable<UIImage> {
        Observable<URL?>.never().startWith(url)
            // SEND TO BACKGROUND THREAD
            .observe(on: backgroundScheduler)
            .flatMapLatest { url throws -> Observable<UIImage> in
                guard let url = url else { return Observable.just(UIImage()) }
                return downloadTask(url: url)
            }
        // SEND BACK TO MAIN THREAD
            .observe(on: MainScheduler.instance)
    }

    func getEmojisList() -> Single<[Emoji]> {
        guard let emojiService = emojiService else {
            return Single<[Emoji]>.error(ServiceError.cannotInstanciate)
        }

        return emojiService.getEmojisList()
            .map({ emojiList in
                var emojis = emojiList
                emojis.sort()
                return emojis
            })
    }
}

func downloadTask(url: URL, placeholder: UIImage = UIImage()) -> Observable<UIImage> {
    guard let request = try? URLRequest(url: url, method: .get) else { return Observable.just(placeholder) }
    return URLSession.shared.rx.response(request: request)
        .map { (response: HTTPURLResponse, data: Data) -> UIImage in
            guard
                response.statusCode == 200,
                let image = UIImage(data: data)
            else { return placeholder }
            return image
        }
}

enum ServiceError: Error {
    case cannotInstanciate
}
