//
//  NSManagedObject+ToEmoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 11/10/2022.
//

import CoreData

extension NSManagedObject {
    func toEmoji() -> Emoji? {
        guard let name = self.value(forKey: "name") as? String else { return nil }
        guard let url = self.value(forKey: "imageUrl") as? String else { return nil }
        guard let urlImage = URL(string: url) else { return nil }
        return Emoji(name: name, urlImage: urlImage)
    }
}
