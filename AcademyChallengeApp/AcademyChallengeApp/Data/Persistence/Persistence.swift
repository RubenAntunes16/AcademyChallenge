//
//  EntityToPersist.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import UIKit
import CoreData

import RxSwift

protocol Persistence {
/* When defining a protocol, it’s sometimes useful to declare one or more associated types as part of the
 protocol’s definition. An associated type gives a placeholder name to a type that’s used as part of the protocol. The
 actual type to use for that associated type isn’t specified until the protocol is adopted. Associated types are
 specified with the associatedtype keyword.
 */
    associatedtype ObjectType

    func persist(object: ObjectType) -> Completable

    func fetch() -> Single<[ObjectType]>
}

enum PersistenceError: Error {
    case fetchError
    case selfError
    case saveContextError
}
