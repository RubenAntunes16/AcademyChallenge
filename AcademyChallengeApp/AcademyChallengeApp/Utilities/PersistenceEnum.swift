//
//  PersistenceEnum.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 23/11/2022.
//

import Foundation

enum PersistenceError: Error {
    case fetchError
    case selfError
    case saveContextError
}
