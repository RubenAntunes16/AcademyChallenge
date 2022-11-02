//
//  AvatarEntity.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import UIKit
import CoreData

class AvatarPersistence {

    var persistenceArray: [NSManagedObject] = []
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

    func persist(currentAvatar: Avatar) {

        let managedContext = self.persistentContainer.viewContext

        // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
        let entity = NSEntityDescription.entity(forEntityName: "AvatarEntity", in: managedContext)!

        let avatar = NSManagedObject(entity: entity, insertInto: managedContext)

        avatar.setValue(currentAvatar.name, forKeyPath: "name")
        avatar.setValue(currentAvatar.avatarUrl.absoluteString, forKeyPath: "avatarUrl")
        avatar.setValue(currentAvatar.id, forKeyPath: "id")

        // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
        // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("[PERSIST] Could not save. \(error), \(error.userInfo)")
        }
    }

//    func persist(currentAvatar: Avatar, _ resultHandler: @escaping (Result<Avatar,Error>) -> Void) {
//
//
//        let managedContext = self.appDelegate.persistentContainer.viewContext
//
//        // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
//        let entity = NSEntityDescription.entity(forEntityName: "AvatarEntity",in: managedContext)!
//
//        let avatar = NSManagedObject(entity: entity,insertInto: managedContext)
//
//        // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
//        avatar.setValue(currentAvatar.name, forKeyPath: "name")
//        avatar.setValue(currentAvatar.avatarUrl, forKeyPath: "avatarUrl")
//        avatar.setValue(currentAvatar.id, forKeyPath: "id")
//
//        // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
//        // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
//        do {
//            try managedContext.save()
//            resultHandler(.success(avatar.ToAvatar()))
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//            resultHandler(.failure(error))
//        }
//
//
//    }

//    func persist(name: String, urlImage: String) {
//
//        // IT'S NECESSARY TO GET DELEGATE SO WE CAN GET ACCESS TO THE MANAGED CONTEXT
//        // WE NEED TO GET THE APPLICATION DELEGATE SO WE CAN GET A REFERENCE TO THE MANAGED CONTEXT
//       DispatchQueue.main.async { [weak self] in
//           guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//           // FIRST THING TO DO SO WE CAN WORK WITH NSManagedObject
//           let managedContext = appDelegate.persistentContainer.viewContext
//
//           // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
//           let entity = NSEntityDescription.entity(forEntityName: "EmojiEntity",in: managedContext)!
//
//           let emoji = NSManagedObject(entity: entity,insertInto: managedContext)
//
//           // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
//           emoji.setValue(name, forKeyPath: "name")
//           emoji.setValue(urlImage, forKeyPath: "imageUrl")
//
//           // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
//           // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
//           do {
//               try managedContext.save()
//               self?.emojisPersistence.append(emoji)
//           } catch let error as NSError {
//               print("Could not save. \(error), \(error.userInfo)")
//           }
//        }
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//
//    }

    func fetch(_ resulthandler: @escaping (Result<[Avatar], Error>) -> Void) {
        var resultFetch: [NSManagedObject]
        var result: [Avatar] = []
//        guard let appDelegate =
//          UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }

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
