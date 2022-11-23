//
//  AvatarEntity.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import UIKit
import CoreData
import RxSwift

enum AvatarError: Error {
    case getAvatarError
    case deleteAvatarError
    case serviceNotAvailable
}

class AvatarPersistence: Persistence {

    var persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

//    func verifyAvatarExist(searchText: String, _ resultHandler: @escaping (Result<[Avatar], Error>) -> Void) {
//        let managedContext = self.persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")
//
//        fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", searchText)
//
//        do {
//            let result = try managedContext.fetch(fetchRequest)
//
//            var toAvatarList: [Avatar] = []
//
//            result.forEach { item in
//                guard let avatar = item.toAvatar() else { return }
//                toAvatarList.append(avatar)
//            }
//
//            resultHandler(.success(toAvatarList))
//        } catch {
//            print(error)
//            resultHandler(.failure(error))
//        }
//    }

    func verifyAvatarExist(searchText: String) -> Observable<Avatar?> {

        return Observable<Avatar?>.create({ observer in
            let disposable: Disposable = Disposables.create()
            let managedContext = self.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

            fetchRequest.predicate = NSPredicate(format: "name ==[cd] %@", searchText)

            guard
                let result: [NSManagedObject] = try? managedContext.fetch(fetchRequest)
            else {
                print("Fetch Error")
                return disposable
            }

            observer.onNext(result.first?.toAvatar())

            return disposable
        })
    }

    func persist(object: Avatar) -> Completable {

        return Completable.create { [weak self] completable in
            let disposable: Disposable = Disposables.create {}

            guard let self = self else {
                completable(.error(PersistenceError.selfError))
                return disposable
            }
            let managedContext = self.persistentContainer.viewContext

            // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
            let entity = NSEntityDescription.entity(forEntityName: "AvatarEntity", in: managedContext)!

            let avatar = NSManagedObject(entity: entity, insertInto: managedContext)

            avatar.setValue(object.name, forKeyPath: "name")
            avatar.setValue(object.avatarUrl.absoluteString, forKeyPath: "avatarUrl")
            avatar.setValue(object.id, forKeyPath: "id")

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

//    func fetch(_ resulthandler: @escaping (Result<[Avatar], Error>) -> Void) {
//        var resultFetch: [NSManagedObject]
//        var result: [Avatar] = []
//
//        let managedContext = self.persistentContainer.viewContext
//
//        // FETCH ALL THE DATA FROM THE ENTITY PERSON
//        let fetchRequest =
//        NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")
//
//        /* WE GET THE DATA THOUGH THE FETCHREQUEST CRITERIA, IN THIS CASE WE ASK THE MANAGED CONTEXT TO
//         SEND ALL THE DATA FROM THE PERSON ENTITY */
//        do {
//            resultFetch = try managedContext.fetch(fetchRequest)
//
//            result = resultFetch.compactMap({ item -> Avatar? in
//                item.toAvatar()
//            })
//
//            resulthandler(.success(result))
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//            resulthandler(.failure(error))
//        }
//    }

    func fetch() -> Single<[Avatar]> {

        return Single<[Avatar]>.create(subscribe: { [weak self] single in

            let disposable: Disposable = Disposables.create()
            guard let self = self else {
                single(.failure(PersistenceError.fetchError))
                return disposable
            }

            let managedContext = self.persistentContainer.viewContext

            // FETCH ALL THE DATA FROM THE ENTITY PERSON
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

            guard
                let resultFetch = try? managedContext.fetch(fetchRequest)
            else {
                single(.failure(PersistenceError.fetchError))
                return disposable
            }

            let result = resultFetch.compactMap({ item -> Avatar? in
                item.toAvatar()
            })

            single(.success(result))

            return disposable
        })
    }

    func delete(avatar: Avatar) -> Completable {

        return Completable.create { completable in
            let disposable: Disposable = Disposables.create {}

            let managedContext = self.persistentContainer.viewContext

            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

            fetchRequest.predicate = NSPredicate(format: "name = %@", avatar.name)

            guard
                let avatarResult = try? managedContext.fetch(fetchRequest),
                let avatarToDelete = avatarResult.first
            else {
                completable(.error(AvatarError.getAvatarError))
                return disposable
            }

            do {
                managedContext.delete(avatarToDelete)
                try managedContext.save()
            } catch {
                completable(.error(AvatarError.deleteAvatarError))
                return disposable
            }
            completable(.completed)
            return disposable
        }
    }
}
