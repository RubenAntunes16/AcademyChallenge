//
//  EntityToPersist.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 13/10/2022.
//

import UIKit
import CoreData

protocol Persistence {

    associatedtype ObjectType

    func persist(object: ObjectType)

    func fetch(_ resulthandler: @escaping (Result<[ObjectType], Error>) -> Void) 
}
