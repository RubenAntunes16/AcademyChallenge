//
//  Emoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 10/10/2022.
//

import Foundation
import UIKit
import CoreData

class EmojiPersistence {
    
    private var emojisPersistence: [NSManagedObject] = []
    
    func persist(name: String, urlImage: String) {
        
        // IT'S NECESSARY TO GET DELEGATE SO WE CAN GET ACCESS TO THE MANAGED CONTEXT
        // WE NEED TO GET THE APPLICATION DELEGATE SO WE CAN GET A REFERENCE TO THE MANAGED CONTEXT
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        // FIRST THING TO DO SO WE CAN WORK WITH NSManagedObject
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // WE CREATE A NEW MANAGED OBJECT AND INSERT IT INTO THE CONTEXT CREATE ABOVE BY USING THE ENTITY METHOD
        let entity =
        NSEntityDescription.entity(forEntityName: "EmojiEntity",
                                   in: managedContext)!
        
        let emoji = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // KEY PATH !!MUST!! HAVE THE SAME NAME AS THE DATA MODEL, OTHERWISE, THE APP CRASHES
        emoji.setValue(name, forKeyPath: "name")
        emoji.setValue(urlImage, forKey: "imageUrl")
        
        // COMMIT THE NAME IN THE PERSON OBJECT AND USE THE SAVE METHOD TO PERSIST NEW VALUE
        // IT'S A GOOD PRACTICE TO PERSIST THE DATA INSIDE A CATCH, SINCE SAVE CAN THROW AN ERROR
        do {
            try managedContext.save()
            emojisPersistence.append(emoji)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func fetch(){
        
    }
}
