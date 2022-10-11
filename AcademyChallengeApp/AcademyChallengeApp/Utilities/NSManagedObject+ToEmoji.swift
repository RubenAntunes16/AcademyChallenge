//
//  NSManagedObject+ToEmoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 11/10/2022.
//

import Foundation
import CoreData

extension NSManagedObject {
    func ToEmoji() -> Emoji{
        print("NAME: \(self.value(forKey: "name"))  !!  URL IMAGE: \(self.value(forKey: "imageUrl"))")
        return Emoji(name: self.value(forKey: "name") as! String,
                     urlImage: URL(string: self.value(forKey: "imageUrl") as! String)!)
    }
}
