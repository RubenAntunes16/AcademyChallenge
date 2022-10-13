//
//  EntityToPersist.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import UIKit
import CoreData

// vou precisar

// 1 - nome entidade
// 2 - array com os atributos da entidade
protocol EntityToPersist {
    var entityName: String { get }
    var attributes: [String : String] { get set }
}

class Persistence {
    
    var persistenceArray: [NSManagedObject] = []
    var appDelegate: AppDelegate?
    
    init() {
        appDelegate = UIApplication.shared.delegate as? AppDelegate
    }
    
    func persist(entityToPersist: EntityToPersist) {
        
        // IT'S NECESSARY TO GET DELEGATE SO WE CAN GET ACCESS TO THE MANAGED CONTEXT
        // WE NEED TO GET THE APPLICATION DELEGATE SO WE CAN GET A REFERENCE TO THE MANAGED CONTEXT
       DispatchQueue.main.async { [weak self] in
           
           // FIRST THING TO DO SO WE CAN WORK WITH NSManagedObject
           guard let managedContext = self?.appDelegate?.persistentContainer.viewContext else { return }
           
           // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
           let entity = NSEntityDescription.entity(forEntityName: entityToPersist.entityName,in: managedContext)!
           
           let entityPersist = NSManagedObject(entity: entity,insertInto: managedContext)
           
           // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
           entityToPersist.attributes.forEach { (key: String, value: String) in
               entityPersist.setValue(value, forKey: key)
           }
           
           
           // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
           // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
           do {
               try managedContext.save()
               self?.persistenceArray.append(entityPersist)
           } catch let error as NSError {
               print("Could not save. \(error), \(error.userInfo)")
           }
        }
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
        
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
    
    func fetch(entityToPersist: EntityToPersist) -> [NSManagedObject] {
        var array: [NSManagedObject] = []
        guard let appDelegate =
          UIApplication.shared.delegate as? AppDelegate else {
            return array
        }
        
        let managedContext =
          appDelegate.persistentContainer.viewContext
        
        // FETCH ALL THE DATA FROM THE ENTITY PERSON
        let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: entityToPersist.entityName)
        
        // WE GET THE DATA THOUGH THE FETCHREQUEST CRITERIA, IN THIS CASE WE ASK THE MANAGED CONTEXT TO SEND ALL THE DATA FROM THE PERSON ENTITY
        do {
            array = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        return array
    }
    
//    func fetch(entityToPersist: EntityToPesist) -> [NSManagedObject] {
//        var array: [NSManagedObject] = []
//        guard let appDelegate =
//          UIApplication.shared.delegate as? AppDelegate else {
//            return array
//        }
//        
//        let managedContext =
//          appDelegate.persistentContainer.viewContext
//        
//        // FETCH ALL THE DATA FROM THE ENTITY PERSON
//        let fetchRequest =
//        NSFetchRequest<NSManagedObject>(entityName: entityToPersist.entityName)
//        
//        // WE GET THE DATA THOUGH THE FETCHREQUEST CRITERIA, IN THIS CASE WE ASK THE MANAGED CONTEXT TO SEND ALL THE DATA FROM THE PERSON ENTITY
//        do {
//            array = try managedContext.fetch(fetchRequest)
//        } catch let error as NSError {
//          print("Could not fetch. \(error), \(error.userInfo)")
//        }
//        
//        return array
//    }
}
