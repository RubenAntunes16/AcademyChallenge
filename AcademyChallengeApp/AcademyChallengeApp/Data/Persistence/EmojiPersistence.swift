//
//  Emoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 10/10/2022.
//

import Foundation
import CoreData
import UIKit

import RxSwift

class EmojiPersistence: Persistence {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func persist(object: Emoji) -> Completable {

        return Completable.create { [weak self] completable in
            let disposable: Disposable = Disposables.create {}
            guard let self = self else {
                completable(.error(PersistenceError.selfError))
                return disposable
            }

            let managedContext = self.persistentContainer.viewContext

            // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
            let entity = NSEntityDescription.entity(forEntityName: "EmojiEntity", in: managedContext)!

            let emoji = NSManagedObject(entity: entity, insertInto: managedContext)

            // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
            emoji.setValue(object.name, forKeyPath: "name")
            emoji.setValue(object.urlImage.absoluteString, forKeyPath: "imageUrl")

            do {
                try managedContext.save()
            } catch let error as NSError {
                print("[PERSIST] Could not save. \(error), \(error.userInfo)")
                completable(.error(PersistenceError.saveContextError))
                return disposable
            }

            completable(.completed)

            return disposable

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
