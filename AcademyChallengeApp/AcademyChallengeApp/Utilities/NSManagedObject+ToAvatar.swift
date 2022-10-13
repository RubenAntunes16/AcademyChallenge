//
//  NSManagedObject+ToAvatar.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import Foundation
import CoreData

extension NSManagedObject {
    func ToAvatar() -> Avatar{
        return Avatar(
            name: self.value(forKey: "name") as! String,
            id: self.value(forKey: "id") as! Int,
            avatarUrl: URL(string: self.value(forKey: "avatarUrl") as! String)!)
    }
}
