//
//  Application.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 29/09/2022.
//

import Foundation
import CoreData

class Application {
    static var urlSession: URLSession?

    var emojiService: EmojiService
    var avatarService: LiveAvatarService
    var appleReposService: LiveAppleReposService

    init() {
        emojiService = LiveEmojiService(persistentContainer: persistentContainer)
        avatarService = .init(persistentContainer: persistentContainer)
        appleReposService = .init()
    }

    static func initialize() {
//        let sessionConfiguration = URLSessionConfiguration.default
//        sessionConfiguration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        URLSession.shared.configuration.urlCache?.diskCapacity = 100 * 1024 * 1024
//        urlSession = URLSession(configuration: sessionConfiguration)

    }

    // MARK: - Core Data stack

    private var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
