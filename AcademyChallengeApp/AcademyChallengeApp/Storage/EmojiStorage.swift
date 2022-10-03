//
//  EmojiStorage.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 29/09/2022.
//

import Foundation

class LiveEmojiStorage: EmojiStorage  {
    
    var emojis: [Emoji] = []
    
    init(){
    }
    
    func getEmojisList(){
        // METHOD IN EMOJI API
        networkCallExecution(EmojiAPI.getEmojis) { (result: Result<EmojiAPICallResult, Error>) in
            switch result{
            case .success(let success):
                print("Success: \(success)")
                self.emojis = success.emojis
                self.emojis.sort()
            case .failure(let failure):
                print("Failure: \(failure)")
            }
        }
    }
}

protocol EmojiStorage{
    var emojis: [Emoji] { get set }
    //var delegate : EmojiStorageDelegate? { get set }
}

protocol EmojiStorageDelegate: AnyObject {
    func getEmojisList()
}

protocol EmojiPresenter: EmojiStorageDelegate {
    var emojisStorage : EmojiStorage? { get set }
}
