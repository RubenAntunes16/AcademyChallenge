//
//  Emoji.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 10/10/2022.
//

import Foundation
import UIKit
import CoreData

class EmojiPersistence: Persistence {

    private let persistentContainer: NSPersistentContainer

    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }

    func persist(object: Emoji) {

        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

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
    }

    func fetch(_ resulthandler: @escaping (Result<[Emoji], Error>) -> Void) {
        var resultFetch: [NSManagedObject] = []
        var result: [Emoji] = []

        let managedContext = persistentContainer.viewContext

        // FETCH ALL THE DATA FROM THE ENTITY PERSON
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "EmojiEntity")

        // WE GET THE DATA THOUGH THE FETCHREQUEST CRITERIA, IN THIS CASE WE ASK THE MANAGED CONTEXT TO
        // SEND ALL THE DATA FROM THE PERSON ENTITY
        do {
            resultFetch = try managedContext.fetch(fetchRequest)

            result = resultFetch.compactMap({ item -> Emoji? in
                item.toEmoji()
            })

            resulthandler(.success(result))
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
            resulthandler(.failure(error))
        }
    }
}
