//
//  AvatarEntity.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 12/10/2022.
//

import UIKit
import CoreData

class AvatarPersistence {
    
    var persistenceArray : [NSManagedObject] = []
    var appDelegate: AppDelegate
    
    init() {
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func verifyAvatarExist(searchText: String, _ resultHandler: @escaping (Result<[NSManagedObject],Error>) -> Void) {
        let managedContext = self.appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")
        
        fetchRequest.predicate = NSPredicate(format: "name=%@", searchText)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            resultHandler(.success(result))
        } catch {
            print(error)
            resultHandler(.failure(error))
        }
        
    }
    
    func persist(name: String, avatarUrl: String, id: Int, _ resultHandler: @escaping (Result<Avatar,Error>) -> Void) {
        
        
        let managedContext = self.appDelegate.persistentContainer.viewContext
        
        // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
        let entity = NSEntityDescription.entity(forEntityName: "AvatarEntity",in: managedContext)!
        
        let avatar = NSManagedObject(entity: entity,insertInto: managedContext)
        
        // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
        avatar.setValue(name, forKeyPath: "name")
        avatar.setValue(avatarUrl, forKeyPath: "avatarUrl")
        avatar.setValue(id, forKeyPath: "id")
        
        // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
        // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
        do {
            try managedContext.save()
            resultHandler(.success(avatar.ToAvatar()))
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            resultHandler(.failure(error))
        }
        
        
    }
    
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
////        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//
//
//    }
    
    func fetch(_ resulthandler: @escaping ([NSManagedObject]) -> Void) {
        var array: [NSManagedObject]
//        guard let appDelegate =
//          UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }

        let managedContext = self.appDelegate.persistentContainer.viewContext

        // FETCH ALL THE DATA FROM THE ENTITY PERSON
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "AvatarEntity")

        // WE GET THE DATA THOUGH THE FETCHREQUEST CRITERIA, IN THIS CASE WE ASK THE MANAGED CONTEXT TO SEND ALL THE DATA FROM THE PERSON ENTITY
        do {
            array = try managedContext.fetch(fetchRequest)
            resulthandler(array)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
}

