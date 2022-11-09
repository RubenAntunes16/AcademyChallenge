//
//  Observable+asOptional.swift
//  AcademyChallengeApp
//
//  Created by Rúben Antunes on 08/11/2022.
//

import Foundation
import RxSwift

extension Observable {
     // swiftlint:disable:next syntactic_sugar
     typealias OptionalElement = Optional<Element>

    // THIS WILL TRANSFORM A OBSERVABLE INTO A OPTIONAL(?) OBSERVABLE
     func asOptional() -> Observable<OptionalElement> {
         return map({ element -> OptionalElement in return element })
     }
 }
