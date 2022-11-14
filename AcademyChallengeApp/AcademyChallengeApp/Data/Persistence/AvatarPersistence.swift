//
//  AvatarEntity.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import UIKit
import CoreData
import RxSwift

class AvatarPersistence: Persistence {

    var persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func verifyAvatarExist(searchText: String, _ resultHandler: @escaping (Result<[Avatar], Error>) -> Void) {
        let managedContext = self.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

        fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", searchText)

        do {
            let result = try managedContext.fetch(fetchRequest)

            var toAvatarList: [Avatar] = []

            result.forEach { item in
                guard let avatar = item.toAvatar() else { return }
                toAvatarList.append(avatar)
            }

            resultHandler(.success(toAvatarList))
        } catch {
            print(error)
            resultHandler(.failure(error))
        }
    }

    func persist(object: Avatar) {

        let managedContext = self.persistentContainer.viewContext

        // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
        let entity = NSEntityDescription.entity(forEntityName: "AvatarEntity", in: managedContext)!

        let avatar = NSManagedObject(entity: entity, insertInto: managedContext)

        avatar.setValue(object.name, forKeyPath: "name")
        avatar.setValue(object.avatarUrl.absoluteString, forKeyPath: "avatarUrl")
        avatar.setValue(object.id, forKeyPath: "id")

        // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
        // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("[PERSIST] Could not save. \(error), \(error.userInfo)")
        }
    }

    func fetch(_ resulthandler: @escaping (Result<[Avatar], Error>) -> Void) {
        var resultFetch: [NSManagedObject]
        var result: [Avatar] = []

        let managedContext = self.persistentContainer.viewContext

        // FETCH ALL THE DATA FROM THE ENTITY PERSON
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

        /* WE GET THE DATA THOUGH THE FETCHREQUEST CRITERIA, IN THIS CASE WE ASK THE MANAGED CONTEXT TO
         SEND ALL THE DATA FROM THE PERSON ENTITY */
        do {
            resultFetch = try managedContext.fetch(fetchRequest)

            result = resultFetch.compactMap({ item -> Avatar? in
                item.toAvatar()
            })

            resulthandler(.success(result))
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            resulthandler(.failure(error))
        }
    }

    func fetch() -> Single<[Emoji]> {

        return Single<[Emoji]>.create(subscribe: { [weak self] single in

            let disposable: Disposable = Disposables.create()
            guard let self = self else {
                single(.failure(PersistenceError.fetchError))
                return disposable
            }

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

    func delete(avatarObject: Avatar) {

        let managedContext = self.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

        fetchRequest.predicate = NSPredicate(format: "name = %@", avatarObject.name)

        do {
            let avatarToDelete = try managedContext.fetch(fetchRequest)
            if avatarToDelete.count == 1 {
                guard let avatar = avatarToDelete.first else { return }
                managedContext.delete(avatar)
                try managedContext.save()
            }

        } catch let error as NSError {
            print("[DELETE AVATAR] Error to delete avatar: \(error)")
        }

    }
}
