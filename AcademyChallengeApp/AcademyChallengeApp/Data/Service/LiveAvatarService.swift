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
        
        persistence.fetch() { (result: Result<[NSManagedObject],Error>) in
            switch result {
            case .success(let success):
                var avatars: [Avatar] = []
                if success.count != 0 {
                    // TRANSFORM NSMANAGEDOBJECT ARRAY TO AVATAR ARRAY
                    avatars = success.map({ item in
                        return item.ToAvatar()
                    })
                }
                
                resultHandler(avatars)
            case .failure(let failure):
                print("[FETCH AVATAR LIST] Error to get avatars from memory: \(failure)")
            }
            
        }
    }
    
    func getAvatar(searchText: String, _ resultHandler: @escaping (Result<Avatar, Error>) -> Void){
        
        persistence.verifyAvatarExist(searchText: searchText) { ( result: Result<[NSManagedObject], Error>) in
            switch result {
            case .success(let success):
                if success.count != 0 {
                    
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
                    
                    let decoder = JSONDecoder()
                    var request = URLRequest(url: URL(string: "https://api.github.com/users/\(searchText)")!)
                    request.httpMethod = Method.get.rawValue
//                    call.headers.forEach { (key: String, value: String) in
//                        request.setValue(value, forHTTPHeaderField: key)
//                    }

                    let task = URLSession.shared.dataTask(with: request) { data, response, error in
                        if let data = data {
                            if let result = try? decoder.decode(Avatar.self, from: data) {
                                self.persistence.persist(currentAvatar: result)
                                resultHandler(.success(result))
                            } else {
                                resultHandler(.failure(APIError.unknownError))
                            }
                        } else if let error = error {
                            resultHandler(.failure(error))
                        }
                    }

                    task.resume()
                }
            case .failure(let failure):
                print("Failure to verify if avatar exists in Core data: \(failure)")
            }
        }
        
    }
    
    func deleteAvatar(avatarToDelete: Avatar, _ resultHandler: @escaping ([Avatar]) -> Void) {
        
        persistence.delete(avatarObject: avatarToDelete)
        fetchAvatarList { (result: [Avatar]) in
            resultHandler(result)
        }
    }
}
