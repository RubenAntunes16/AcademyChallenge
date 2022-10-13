//
//  AvatarService.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import UIKit
import CoreData

class LiveAvatarService {
    
    private var networkManager: NetworkManager = .init()
    private let persistence: AvatarPersistence = .init()
    
    
    func fetchAvatarList(_ resultHandler: @escaping ([Avatar]) -> Void){
        
        persistence.fetch() { (result: [NSManagedObject]) in
            if !result.isEmpty {
                // TRANSFORM NSMANAGEDOBJECT ARRAY TO AVATAR ARRAY
                let avatars = result.map({ item in
                    return item.ToAvatar()
                })
                
                resultHandler(avatars)
                
            }
        }
    }
    
    func getAvatar(searchText: String, _ resultHandler: @escaping (Result<Avatar, Error>) -> Void){
        
        persistence.verifyAvatarExist(searchText: searchText) { ( result: Result<[NSManagedObject], Error>) in
            switch result {
            case .success(let success):
                if !success.isEmpty {
                    
                    guard let avatarFound = success.first else { return }
                    
                    resultHandler(.success(avatarFound.ToAvatar()))
                } else {
                    // GET THE AVATAR FROM API
                    //AvatarAPI.getAvatars.url = URL(string: "https://api.github.com/users/\(searchText)")!
                    //
                    //            networkManager.executeNetworkCall(AvatarAPI.getAvatars) { (result: Result<Avatar, Error>) in
                    //                    switch result{
                    //                    case .success(let success):
                    //    //                    print("Success: \(success.emojis)")
                    //                        resultHandler(.success(success))
                    //                    case .failure(let failure):
                    //                        print("Failure: \(failure)")
                    //                        resultHandler(.failure(failure))
                    //                    }
                    //                }
                }
            case .failure(let failure):
                print("Failure to verify if avatar exists in Core data: \(failure)")
            }
        }
        
    }
}
