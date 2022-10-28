//
//  NSManagedObject+ToAvatar.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import Foundation
import CoreData

extension NSManagedObject {
    func toAvatar() -> Avatar? {
        guard let name = self.value(forKey: "name") as? String else { return nil }
        guard let id = self.value(forKey: "id") as? Int else { return nil }
        guard let url = self.value(forKey: "avatarUrl") as? String else { return nil }
        guard let avatarUrl = URL(string: url) else { return nil }
        return Avatar(
            name: name,
            id: id,
            avatarUrl: avatarUrl)
    }
}
