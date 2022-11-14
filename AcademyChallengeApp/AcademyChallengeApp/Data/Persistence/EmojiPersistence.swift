//
//  Emoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 10/10/2022.
//

import Foundation
import UIKit
import CoreData
import RxSwift

class EmojiPersistence: Persistence {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func persist(object: Emoji) {

        // FIRST THING TO DO SO WE CAN WORK WITH NSManagedObject
        let managedContext = self.persistentContainer.viewContext

        // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
        let entity = NSEntityDescription.entity(forEntityName: "EmojiEntity", in: managedContext)!

        let emoji = NSManagedObject(entity: entity, insertInto: managedContext)

        // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
        emoji.setValue(object.name, forKeyPath: "name")
        emoji.setValue(object.urlImage.absoluteString, forKeyPath: "imageUrl")

        // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
        // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetch() -> Single<[Emoji]> {

        return Single<[Emoji]>.create(subscribe: { single in

            let disposable: Disposable = Disposables.create()

            let managedContext = self.persistentContainer.viewContext

            // FETCH ALL THE DATA FROM THE ENTITY PERSON
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EmojiEntity")

            guard
                let resultFetch = try? managedContext.fetch(fetchRequest)
            else {
                single(.failure(PersistenceError.fetchError))
                return disposable
            }

            let result = resultFetch.compactMap({ item -> Emoji? in
                item.toEmoji()
            })

            single(.success(result))

            return disposable
        })
    }
}

enum PersistenceError: Error {
    case fetchError
}
