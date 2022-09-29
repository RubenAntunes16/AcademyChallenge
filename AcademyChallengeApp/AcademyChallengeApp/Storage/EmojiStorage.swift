//
//  EmojiStorage.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 29/09/2022.
//

import Foundation

protocol EmojiStorage{
    var emojis: [Emoji] {
        get set
    }
}

//class LiveEmojiStorage: EmojiStorage {
//    var emojisList: [Emoji]
//    let url = URL(string: "https://api.github.com/emojis")!
//    
//    init(){
//        getEmojis()
//    }
//    
//    func getEmojis() {
//
//        var request = URLRequest(url: url)
//
//        print(request)
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        let task = URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                let json = try? JSONSerialization.jsonObject(with: data) as? Dictionary<String,String>
//        //        print(json!)
//        //        print(data)
//                //print(String(data: data, encoding: .utf8))
//                if let array = json {
//                    print(array.count)
//                    for (emojiName,emojiUrl) in array {
//                        self.emojisList.append(Emoji(name: emojiName, urlImage: emojiUrl))
//                        //print("Item \(emojiName) - URL: \(emojiUrl)\n")
//                    }
//                    self.getRandomEmoji()
//                }
//                
//                //print(String(data: data, encoding: .utf8))
//            } else if let error = error {
//                print("HTTP Request Failed \(error)")
//            }
//        }
//
//        task.resume()
//    }
//}
//
//protocol EmojiStorageDelegate: AnyObject {
//    
//}
