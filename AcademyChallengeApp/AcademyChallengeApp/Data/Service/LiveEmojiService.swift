//
//  EmojiService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 04/10/2022.
//

import Foundation
import CoreData

class LiveEmojiService : EmojiService{
    
    private var networkManager: NetworkManager = .init()
    private let persistence: EmojiPersistence = .init()
//    private let decoder: EmojiPersistenceDecode = EmojiPersistenceDecode()
    
//    typealias T = EmojiAPICallResult
    
    func getEmojisList(_ resultHandler: @escaping (Result<[Emoji], Error>) -> Void){
        var fetchedEmojis : [NSManagedObject] = []

        persistence.fetch() { (result: [NSManagedObject]) in
            fetchedEmojis = result
        }
        
        
        if !fetchedEmojis.isEmpty {
            let emojis = fetchedEmojis.map({ item in
                return Emoji(name: item.value(forKey: "name") as! String, urlImage: URL(string: item.value(forKey: "imageUrl") as! String)!)
            })
            
            resultHandler(.success(emojis))
            
        }else {
            // METHOD IN EMOJI API
                networkManager.executeNetworkCall(EmojiAPI.getEmojis) { (result: Result<EmojiAPICallResult, Error>) in
                    switch result{
                    case .success(let success):
    //                    print("Success: \(success.emojis)")
                        resultHandler(.success(success.emojis))
                    case .failure(let failure):
                        print("Failure: \(failure)")
                        resultHandler(.failure(failure))
                    }
                }
        }
        
    }
}


